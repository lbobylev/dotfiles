require 'mason'.setup()
require 'mason-lspconfig'.setup {
    ensure_installed = {
        'ts_ls',
        'efm',
        'bashls',
        'cssls',
        'html',
        'gradle_ls',
        'groovyls',
        'lua_ls',
        'jsonls',
        'yamlls',
        'lemminx',
        'marksman',
        'vimls',
        'pyright',
        'ruff',
        'angularls',
        'taplo'
    }
}

local lspconfig = require 'lspconfig'
local lsp_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
local lsp_attach = function(client, bufnr)
    require 'lsp_mappings'.setup(bufnr)
end

require 'mason-lspconfig'.setup_handlers {
    function(server_name)
        if server_name == 'jdtls' then
            -- do nothing
        elseif server_name == 'pyright' then
            local function get_python_path()
                local handle = io.popen("which python")
                local result = handle:read("*a")
                handle:close()
                return result:gsub("%s+", "") -- Trim any whitespace
            end

            lspconfig.pyright.setup {
                on_attach = function(client, bufnr)
                    vim.api.nvim_set_keymap('n', '<F5>', ':!python %<CR>',
                        { noremap = true, silent = true, desc = 'Run' })

                    local function format_python()
                        vim.cmd("write")
                        vim.cmd("!black %")
                        vim.cmd("edit!")
                    end

                    vim.keymap.set({ 'n', 'v' }, '<leader>f', format_python, { desc = 'Format code', buffer = bufnr })

                    require "lsp_signature".on_attach({
                        bind = true,
                        floating_window_above_cur_line = true,
                        hint_enable = false,
                    }, bufnr)

                    lsp_attach(client, bufnr)
                end,
                capabilities = lsp_capabilities,
                settings = {
                    python = {
                        pythonPath = get_python_path(),
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic",
                            autoImportCompletions = true,
                        },
                        disableOrganizeImports = true,
                    },
                },
            }
        elseif server_name == 'ruff' then
            lspconfig.ruff.setup {
                on_attach = function(client, bufnr)
                    -- Fix all with Ruff
                    vim.keymap.set('n', '<leader>rf', function()
                        vim.lsp.buf.code_action({
                            apply = true,
                            context = { only = { 'source.fixAll' } },
                        })
                    end, { buffer = bufnr, desc = 'Ruff: Fix all' })

                    -- Auto-fix on save
                    -- vim.api.nvim_create_autocmd('BufWritePre', {
                    --     buffer = bufnr,
                    --     callback = function()
                    --         vim.lsp.buf.code_action({
                    --             apply = true,
                    --             context = { only = { 'source.fixAll' } },
                    --         })
                    --     end,
                    -- })

                    lsp_attach(client, bufnr)
                end,
                capabilities = lsp_capabilities,
                init_options = {
                    settings = {
                        args = {}, -- e.g., { "--line-length=100" }
                    },
                },
            }
        elseif server_name == 'efm' then
            local bin_path = './node_modules/.bin'
            local eslint = {
                lintCommand = bin_path .. '/eslint -f unix --stdin --stdin-filename ${INPUT}',
                lintStdin = true,
                lintFormats = { '%f:%l:%c: %m' },
                formatCommand = bin_path .. '/prettier --stdin-filepath ${INPUT}',
                formatStdin = true
            }
            lspconfig.efm.setup {
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescript.tsx",
                    "typescriptreact"
                },
                init_options = { documentFormatting = true },
                settings = {
                    rootMarkers = { ".git/" },
                    languages = {
                        typescript = { eslint },
                        javascript = { eslint },
                        typescriptreact = { eslint },
                        javascriptreact = { eslint },
                        ['javascript.jsx'] = { eslint },
                        ['typescript.tsx'] = { eslint },
                    }
                }
            }
            vim.cmd 'command! -nargs=0 Lint :lua vim.lsp.buf.format()'
            vim.cmd [[
              augroup LintAutogroup
                autocmd!
                autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx Lint
              augroup END
            ]]
        elseif server_name == 'ts_ls' then
            lspconfig.ts_ls.setup {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    lsp_attach(client, bufnr)
                end,
                capabilities = lsp_capabilities
            }
        else
            lspconfig[server_name].setup {
                on_attach = lsp_attach,
                capabilities = lsp_capabilities
            }
        end
    end
}

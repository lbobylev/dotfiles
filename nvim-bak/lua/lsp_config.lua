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

local default_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
local default_on_attach = function(client, bufnr)
    require 'lsp_mappings'.setup(bufnr)
end

local default_config = {
    on_attach = default_on_attach,
    capabilities = default_capabilities
}

for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
    vim.lsp.config(server, default_config)
end

vim.lsp.config('pyright', {
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

        default_on_attach(client, bufnr)
    end,
    capabilities = default_capabilities,
    settings = {
        python = {
            pythonPath = (function()
                local handle = io.popen("which python")
                local result = handle:read("*a")
                handle:close()
                return result:gsub("%s+", "") -- Trim any whitespace
            end)(),
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
})

vim.lsp.config('ruff', {
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

        default_on_attach(client, bufnr)
    end,
    capabilities = default_capabilities,
    init_options = {
        settings = {
            args = {}, -- e.g., { "--line-length=100" }
        },
    },
})

vim.lsp.config('efm', {
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
        "html",
        "htmlangular",
        "css",
    },
    init_options = { documentFormatting = true },
    settings = (function()
        local bin_path = './node_modules/.bin'
        local eslint = {
            lintCommand = bin_path .. '/eslint -f unix --stdin --stdin-filename ${INPUT}',
            lintStdin = true,
            lintFormats = { '%f:%l:%c: %m' },
            formatCommand = bin_path .. '/prettier --stdin-filepath ${INPUT}',
            formatStdin = true
        }
        local prettier_only = {
            formatCommand = bin_path .. '/prettier --stdin-filepath ${INPUT}',
            formatStdin = true,
        }
        return {
            rootMarkers = { ".git/" },
            languages = {
                typescript = { eslint },
                javascript = { eslint },
                typescriptreact = { eslint },
                javascriptreact = { eslint },
                ['javascript.jsx'] = { eslint },
                ['typescript.tsx'] = { eslint },
                html = { prettier_only },
                htmlangular = { prettier_only },
                css = { prettier_only },
            }
        }
    end)(),
    on_attach = function(client, bufnr)
        vim.cmd 'command! -nargs=0 Lint :lua vim.lsp.buf.format()'
        vim.cmd [[
              augroup LintAutogroup
                autocmd!
                autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx Lint
              augroup END
            ]]
    end
})

vim.lsp.config('ts_ls', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        default_on_attach(client, bufnr)
    end,
    capabilities = default_capabilities
})

vim.lsp.config('lua_ls', {
    on_attach = function(client, bufnr)
        default_on_attach(client, bufnr)
    end,
    capabilities = default_capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

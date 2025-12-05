local map = vim.keymap.set

return {
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                -- 'ts_ls',
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
            },
            -- automatic_installation = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, -- ленивая загрузка
        config = function()
            local default_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
            local default_on_attach = function(client, bufnr)
                require 'lsp_mappings'.setup(bufnr)
            end

            local default_config = {
                on_attach = default_on_attach,
                capabilities = default_capabilities
            }

            local special = {
                pyright = true,
                ruff = true,
                efm = true,
                lua_ls = true,
                ts_ls = true,
                angularls = true,
            }

            for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
                if not special[server] then
                    vim.lsp.config(server, default_config)
                end
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

                    map({ 'n', 'v' }, '<leader>f', format_python, { desc = 'Format code', buffer = bufnr })

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
                    map('n', '<leader>rf', function()
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

            -- vim.lsp.config('ts_ls', {
            --     on_attach = function(client, bufnr)
            --         client.server_capabilities.documentFormattingProvider = false
            --         client.server_capabilities.documentRangeFormattingProvider = false
            --         default_on_attach(client, bufnr)
            --     end,
            --     capabilities = default_capabilities
            -- })

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

            vim.lsp.config('angularls', {
                on_attach = function(client, bufnr)
                    default_on_attach(client, bufnr)

                    if client.name == "angularls" then
                        -- ❌ отключаем задваивание "Find References"
                        client.server_capabilities.referencesProvider = false

                        -- ❗ оставляем переход к определениям
                        -- (это обеспечивает переход из HTML → TS)
                        client.server_capabilities.definitionProvider = true

                        -- По желанию также можно отключить rename/implementation
                        -- client.server_capabilities.renameProvider = false
                        -- client.server_capabilities.implementationProvider = false
                    end
                end,
                capabilities = default_capabilities,
                filetypes = { "html", "htmlangular", "typescript" },
            })
        end
    },
    { 'ray-x/lsp_signature.nvim', opts = {} },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        ft = {
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact",
        },
        config = function()
            require("typescript-tools").setup({
                on_attach = function(client, bufnr)
                    -- чтобы форматирование оставалось за efm (eslint/prettier)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false

                    require("lsp_mappings").setup(bufnr)
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
        end,
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" }
            },                               -- optional: you can also use fzf-lua, snacks, mini-pick instead.
        },
        ft = "python",                       -- Load when opening Python files
        keys = {
            { "<leader>sv", "<cmd>VenvSelect<cr>", desc = "Select venv env" }, -- Open picker on keymap
        },
        opts = {                             -- this can be an empty lua table - just showing below for clarity.
            search = {},                     -- if you add your own searches, they go here.
            options = {}                     -- if you add plugin options, they go here.
        },
    },
}

vim.cmd('syntax enable')
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.termguicolors = true

local map = vim.keymap.set

-- Настройка горячих клавиш для перемещения между буферами
vim.api.nvim_set_keymap('n', '<leader>j', ':bprevious<CR>',
    { noremap = true, silent = true, desc = 'Previous buffer' })
vim.api.nvim_set_keymap('n', '<leader>k', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })

map('n', '<leader>ga', ':!git add %<CR>', { desc = 'Git add buffer' })

vim.diagnostic.config({
    virtual_text = true
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        "tanvirtin/monokai.nvim",
        config = function()
            require("monokai").setup({
                palette = {
                    base2 = "#000000",
                    base3 = "#000000",
                },
            })
        end,
    },
    {
        'folke/which-key.nvim'
    },
    {
        'akinsho/bufferline.nvim',
        config = function()
            require 'bufferline'.setup {}
        end
    },
    {
        'goolord/alpha-nvim',
        config = function()
            require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
        end
    },
    {
        'j-hui/fidget.nvim',
        config = function()
            require 'fidget'.setup {
                progress = {
                    display = {
                        render_limit = 5
                    }
                },
                notification = {
                    window = {
                        -- max_width = 60
                    }
                }
            }
        end
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            local notify = require 'notify'
            vim.notify = notify
            notify.setup {
                max_width = 50,
                max_height = 60,
                render = 'wrapped-default'
            }
        end
    },
    -- {
    --     'hedyhli/outline.nvim',
    --     opts = {}
    -- },
    {
        'stevearc/aerial.nvim',
        opts = {
            min_width = 50,
        }
    },
    -- {
    --     'pogyomo/winresize.nvim',
    --     config = function()
    --         require 'winresize'.setup {}
    --         local resize = function(win, amt, dir)
    --             return function()
    --                require 'winresize'.resize(win, amt, dir)
    --             end
    --         end
    --         map("n", "rh", resize(0, 20, "left"), { desc = "Resize window left" })
    --         map("n", "rj", resize(0, 20, "down"), { desc = "Resize window down" })
    --         map("n", "rk", resize(0, 20, "up"), { desc = "Resize window up" })
    --         map("n", "rl", resize(0, 20, "right"), { desc = "Resize window right" })
    --     end
    -- },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            -- optionally enable 24-bit colour
            vim.opt.termguicolors = true

            local tree_on_attach = function(bufnr)
                local api = require 'nvim-tree.api'
                -- default mappings
                api.config.mappings.default_on_attach(bufnr)
                map('n', '<leader>th', api.tree.toggle_help, { desc = 'Toggle NvimTree help' })
            end

            require 'nvim-tree'.setup {
                sort = {
                    sorter = 'case_sensitive',
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
                on_attach = tree_on_attach
            }

            map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle NvimTree' })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require 'lualine'.setup {
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = {
                        'encoding',
                        'fileformat',
                        'filetype',
                        {
                            -- Custom component to show the current Conda environment only for Python files
                            function()
                                local env = os.getenv("CONDA_DEFAULT_ENV") -- Get the current Conda environment
                                return env and "🐍 " .. env or "" -- Return the environment name with a snake emoji
                            end,
                            color = { fg = '#ff9e64' }, -- Customize the color as needed
                            cond = function()
                                return os.getenv("CONDA_DEFAULT_ENV") ~= nil and
                                    vim.bo.filetype == 'python' -- Check if it's a Python file and an environment is set
                            end
                        }
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            }
        end

    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim"
        },
        config = function()
            local telescope = require 'telescope'

            telescope.setup {
                defaults = {
                    path_display = {
                        shorten = {
                            len = 3, exclude = { 1, -1 }
                        },
                        truncate = true
                    },
                    dynamic_preview_title = true,
                },
                pickers = {
                    find_files = { no_ignore = false, hidden = false }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = 'smart_case',       -- or 'ignore_case' or 'respect_case'
                    }
                }
            }

            local get_opts = function()
                local src_dir = '/Users/leonid/src'
                local cwd = vim.fn.getcwd()
                if string.match(cwd, '^' .. src_dir .. '/ewc%-app%-.+$') then
                    return {
                        search_dirs = { cwd, src_dir .. '/surge-app-unified' }
                    }
                elseif string.match(cwd, '^' .. src_dir .. '/ewc%-web%-.+$') then
                    return {
                        search_dirs = {
                            cwd,
                            src_dir .. '/front-pkg-core',
                            src_dir .. '/front-pkg-catalog',
                            src_dir .. '/front-pkg-dam'
                        }
                    }
                end
                return {}
            end

            local builtin = require 'telescope.builtin'
            map('n', '<leader>ff', function() builtin.find_files(get_opts()) end, { desc = 'Find files' })
            map('n', '<leader>fg', function() builtin.live_grep(get_opts()) end, { desc = 'Live grep' })
            map('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
            map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
            map('n', '<leader>fn', '<cmd>:Telescope notify<CR>', { desc = 'Notify history' })
            map("n", "<leader>fr", builtin.resume, { desc = 'Telescope resume' })

            -- monokai background color
            vim.cmd [[highlight TelescopeNormal guibg=#000000]]

            telescope.load_extension 'fzf'
        end
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
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
        end
    },
    { 'ray-x/lsp_signature.nvim' },
    {
        "mfussenegger/nvim-dap",
        -- event = "VeryLazy",
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", 'nvim-neotest/nvim-nio' },
        config = function()
            local jdtls = require 'jdtls'
            local dap = require 'dap'
            local dapui = require 'dapui'

            dapui.setup {
                layouts = {
                    {
                        elements = {
                            -- { id = "repl",        size = 0.30 },
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        position = "right",
                        size = 5
                    },
                    {
                        elements = {
                            { id = "repl", size = 1 }
                        },
                        position = "bottom",
                        size = 20
                    },
                    {
                        elements = {
                            { id = "console", size = 1 }
                        },
                        position = "bottom",
                        size = 25
                    },
                },
            }

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                -- dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                -- dapui.close()
            end

            -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
            -- you make during a debug session immediately.
            -- Remove the option if you do not want that.
            jdtls.setup_dap { hotcodereplace = 'auto' }
            require 'dap.ext.vscode'.load_launchjs()

            map('n', '<leader>du', function() dapui.toggle { reset = true } end, { desc = 'Toggle dap ui' })
            map('n', '<leader>dU', function() dapui.toggle { reset = true, layout = 1 } end, { desc = 'Toggle dap ui' })
        end
    },

    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip'
        },
        config = function()
            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
            end

            local cmp = require 'cmp'
            local compare = require 'cmp.config.compare'

            cmp.setup {
                sources = {
                    -- { name = 'cmp_tabnine' },
                    -- { name = 'copilot',                group_index = 2 },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'vsnip' },
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        -- require 'cmp_tabnine.compare',
                        -- require 'copilot_cmp.comparators'.prioritize,
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
                    },
                },
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body) -- because we are using the vsnip cmp plugin
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- Ctrl + d
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    -- https://github.com/zbirenbaum/copilot-cmp?tab=readme-ov-file#tab-completion-configuration-highly-recommended
                    ['<Tab>'] = vim.schedule_wrap(function(fallback)
                        if cmp.visible() and has_words_before() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end),
                    ['<S-Tab>'] = cmp.mapping(function(fallback) -- Shift + Tab
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                formatting = {
                    format = require 'lspkind'.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        symbol_map = { Copilot = '' },
                        maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        before = function(entry, vim_item)
                            if entry.source.name == 'cmp_tabnine' then
                                vim_item.kind = '🚀'
                                vim_item.menu = 'Tabnine'
                            end
                            return vim_item
                        end
                    })
                }
            }
        end
    },
    {
        'zbirenbaum/copilot.lua',
        config = function()
            require 'copilot'.setup {
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept_word = '<C-l>', -- Accept suggestion with <C-l>
                    }
                }
            }
            map({ 'n', 'v' }, '<leader>aP', require 'copilot.panel'.open, { desc = 'Copilot - Panel' })
        end,
    },
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            'tpope/vim-fugitive',
            'echasnovski/mini.diff',
            'echasnovski/mini.icons'
        },
        config = function()
            local function trim(s)
                return s:match("^%s*(.-)%s*$")
            end

            local function get_password(entry)
                local file = io.open('/Users/leonid/.' .. entry, "r")
                if file then
                    local content = file:read("*a")
                    file:close()
                    return trim(content)
                else
                    return nil
                end
            end

            local openai_key = get_password 'openai'
            -- local anthropic_key = get_password 'anthropic'
            -- local gemini_key = get_password 'gemini'

            local adapters = require 'codecompanion.adapters'
            require 'codecompanion'.setup {
                strategies = {
                    chat = { adapter = 'openai' },
                    inline = { adapter = 'openai' }
                },
                adapters = {
                    http = {
                        -- ollama = function()
                        --     return adapters.extend('ollama', {
                        --         name = 'llama3',
                        --         schema = {
                        --             model = {
                        --                 default = 'llama3.1:latest',
                        --             },
                        --             num_ctx = {
                        --                 default = 16384,
                        --             },
                        --             num_predict = {
                        --                 default = -1,
                        --             },
                        --         },
                        --     })
                        -- end,
                        openai = function()
                            return adapters.extend('openai', {
                                env = {
                                    api_key = openai_key
                                },
                                schema = {
                                    model = {
                                        default = 'gpt-5.1',
                                        temperature = 0,
                                    }
                                }
                            })
                        end,
                        -- gemini = function()
                        --     return adapters.extend('gemini', {
                        --         env = {
                        --             api_key = gemini_key
                        --         },
                        --         schema = {
                        --             model = {
                        --                 -- gemini-2.5-pro-exp-03-25
                        --                 -- gemini-2.0-flash
                        --                 -- gemini-2.0-pro-exp-02-05
                        --                 -- gemini-1.5-flash
                        --                 -- gemini-1.5-pro
                        --                 -- gemini-1.0-pro
                        --                 default = 'gemini-2.5-pro-preview-05-06'
                        --             }
                        --         }
                        --     })
                        -- end,
                        -- anthropic = function()
                        --     return adapters.extend("anthropic", {
                        --         env = {
                        --             api_key = anthropic_key
                        --         },
                        --         schema = {
                        --             model = {
                        --                 default = "claude-3-5-sonnet-latest"
                        --                 -- default = "claude-3-5-haiku-latest"
                        --             }
                        --         }
                        --     })
                        -- end,
                    }
                },
                display = {
                    chat = {
                        render_headers = false,
                        window = {
                            layout = 'horizontal',
                            width = 1,
                            height = 0.4,
                        }
                    },
                    diff = {
                        provider = 'mini_diff',
                        layout = 'horizontal',
                    }
                }
            }

            require 'plugins.codecompanion.fidget-spinner':init()

            vim.api.nvim_set_keymap('v', "<leader>aa", "<cmd>CodeCompanionActions<cr>",
                { noremap = true, silent = true, desc = 'Code Companion - Actions' })
            vim.api.nvim_set_keymap('n', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
                { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
            vim.api.nvim_set_keymap('v', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
                { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
            vim.api.nvim_set_keymap('v', "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",
                { noremap = true, silent = true, desc = 'Code Companion - Chat add' })

            -- Expand 'cc' into 'CodeCompanion' in the command line
            vim.cmd([[cab cc CodeCompanion]])
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "markdown", "markdown_inline", "latex", "yaml" },
                highlight = {
                    enable = true,
                    -- additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            }
        end
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.nvim",
        },
        ft = { "markdown", "codecompanion" },
        config = function()
            require("render-markdown").setup {
                file_types = { "markdown", "codecompanion" },
            }
        end
    },

    {
        'akinsho/git-conflict.nvim',
        version = '*',
        dependencies = {
            'onsails/lspkind.nvim'
        },
        config = function()
            require 'git-conflict'.setup {}
            map('n', '<leader>cn', '<Plug>(git-conflict-next-conflict)', { desc = 'Go to next conflict' })
            map('n', '<leader>cp', '<Plug>(git-conflict-prev-conflict)', { desc = 'Go to previous conflict' })
            map('n', '<leader>cb', '<Plug>(git-conflict-choose-both)', { desc = 'Choose both changes' })
            map('n', '<leader>ct', '<Plug>(git-conflict-theirs)', { desc = 'Choose their changes' })
            map('n', '<leader>co', '<Plug>(git-conflict-ours)', { desc = 'Choose our changes' })
        end,

    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function()
                map('n', '<leader>gh', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
                map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle current line blame' })
            end
        }
    },
    {
        'linrongbin16/gitlinker.nvim',
        opts = {}
    },
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {}
            vim.api.nvim_set_keymap('n', '<leader>td', ':Trouble diagnostics<CR>',
                { noremap = true, silent = true, desc = 'Trouble diagnostics' })
        end,
    },
    {
        'folke/flash.nvim',
        config = function()
            local f = require 'flash'
            f.setup {}
            map({ 'n', 'x', 'o' }, '<leader>sj', f.jump, { desc = "Flash jump" })
            map({ 'n', 'x', 'o' }, '<leader>st', f.treesitter, { desc = "Flash Treesitter" })
            map('o', 'r', f.remote, { desc = "Remote Flash" })
            map({ 'o', 'x' }, '<leader>sts', f.treesitter_search,
                { desc = "Flash Treesitter Search" })
            map('c', '<c-s>', f.toggle, { desc = "Toggle Flash Search" })
        end
    },
    {
        'nvim-pack/nvim-spectre',
        config = function()
            local spectre = require 'spectre'
            spectre.setup {
                default = {
                    replace = {
                        cmd = 'sd'
                    }
                }
            }
            map('n', '<leader>S', spectre.toggle, { desc = 'Toggle Spectre' })
            map({ 'n', 'v' }, '<leader>sw', function()
                spectre.open_visual(vim.fn.mode() == 'v' and { select_word = true } or {})
            end, { desc = 'Search current word' })
            map('n', '<leader>sp', function() spectre.open_file_search { select_word = true } end,
                { desc = 'Search on current file' })
        end
    },
    {
        'windwp/nvim-autopairs',
        opts = {}
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        config = function()
            vim.o.foldcolumn = '1' -- Указывает, сколько колонок отводить под индикаторы сворачивания
            vim.o.foldlevel = 99   -- Уровень сворачивания (99 означает, что код изначально не свернут)
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        opts = {
            close_fold_kinds_for_ft = {
                default = { 'imports', 'comment' },
                json = { 'array' }
            },
            provider_selector = function()
                return { 'treesitter', 'indent' }
            end
        }
    }
}

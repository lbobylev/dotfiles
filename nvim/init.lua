-- Initialize plugin manager
vim.cmd('packadd packer.nvim')

require 'packer'.startup(function(use)
    use 'tanvirtin/monokai.nvim'
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-jdtls'
    use 'nvim-neotest/nvim-nio'
    use 'rcarriga/nvim-dap-ui'
    use 'rcarriga/nvim-notify' -- optional dependency for folke/noice.nvim
    use "ray-x/lsp_signature.nvim"
    use 'j-hui/fidget.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use "rebelot/kanagawa.nvim"
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'lewis6991/gitsigns.nvim'
    use 'tpope/vim-fugitive'
    use 'linrongbin16/gitlinker.nvim'
    use { 'akinsho/bufferline.nvim', tag = '*' }
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'kevinhwang91/promise-async'
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
    use 'zbirenbaum/copilot.lua'
    use 'zbirenbaum/copilot-cmp'
    use 'folke/trouble.nvim'
    use 'folke/which-key.nvim'
    use 'nvim-pack/nvim-spectre'
    use 'goolord/alpha-nvim'
    use 'echasnovski/mini.diff'
    use 'echasnovski/mini.icons'
    use 'onsails/lspkind.nvim'
    use 'hedyhli/outline.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate', -- Automatically install parsers
    }
    use {
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require 'render-markdown'.setup {
                file_types = { 'markdown', 'codecompanion' },
            }
        end,
    }
    use {
        'olimorris/codecompanion.nvim',
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            -- "nvim-telescope/telescope.nvim",                                                       -- Optional: For using slash commands
            -- "stevearc/dressing.nvim"                                                               -- Optional: Improves `vim.ui.select`
        }
    }
    use 'akinsho/git-conflict.nvim'
    use 'pogyomo/winresize.nvim'
    use 'stevearc/aerial.nvim'
    -- use 'pwntester/octo.nvim'
    use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
end)

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Set line numbers
vim.opt.number = true

-- Set tab and indentation options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

if vim.g.started_by_firenvim then
    vim.g.firenvim_config = {
        -- globalSettings = { alt = "all" },
        localSettings = {
            [".*"] = {
                -- cmdline  = "neovim",
                -- content  = "text",
                -- priority = 0,
                -- selector = "textarea",
                takeover = "never" -- always, empty, never, nonempty or once
            }
        }
    }
else
    -- Set leader keys
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- Настройка горячих клавиш для перемещения между буферами
    vim.api.nvim_set_keymap('n', '<leader>j', ':bprevious<CR>',
        { noremap = true, silent = true, desc = 'Previous buffer' })
    vim.api.nvim_set_keymap('n', '<leader>k', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })

    vim.diagnostic.config({
        virtual_text = true
        -- virtual_lines = {
        --     format = function(diagnostic)
        --         local max_width = vim.api.nvim_win_get_width(0) - 60 -- Adjust width dynamically
        --         local lines = {}
        --         local message = diagnostic.message
        --         while #message > max_width do
        --             table.insert(lines, message:sub(1, max_width))
        --             message = message:sub(max_width + 1)
        --         end
        --         table.insert(lines, message)
        --         return table.concat(lines, "\n") -- Join lines with a newline
        --     end
        -- }
    })

    -- require 'octo'.setup {}

    require 'aerial'.setup {
        min_width = 50,
    }

    require 'monokai'.setup {
        palette = {
            -- base1 = "#000000", -- Set the main background color to black
            base2 = "#000000", -- Set secondary background color to black
            base3 = "#000000", -- Set tertiary background color to black
            -- base4 = "#000000", -- Set quaternary background color to black
        },
        -- custom_hlgroups = {
        --     Normal = {
        --         bg = "#000000" -- Ensure normal text has a black background
        --     },
        --     NormalFloat = {
        --         bg = "#000000" -- Set floating window background to black
        --     }
        -- }
    }

    vim.keymap.set('n', '<leader>du', function()
        require 'dapui'.toggle { reset = true }
    end, { desc = 'Toggle dap ui' })

    vim.keymap.set('n', '<leader>dU', function()
        require 'dapui'.toggle { reset = true, layout = 1 }
    end, { desc = 'Toggle dap ui' })

    local resize = function(win, amt, dir)
        return function()
            require 'winresize'.resize(win, amt, dir)
        end
    end
    vim.keymap.set("n", "rh", resize(0, 20, "left", { desc = "Resize window left" }))
    vim.keymap.set("n", "rj", resize(0, 20, "down", { desc = "Resize window down" }))
    vim.keymap.set("n", "rk", resize(0, 20, "up", { desc = "Resize window up" }))
    vim.keymap.set("n", "rl", resize(0, 20, "right", { desc = "Resize window right" }))

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

    require 'ai_config'
    require 'git_config'
    require 'cmp_config'
    require 'telescope_config'
    require 'lsp_config'
    require 'nvim_tree_config'
    require 'jdtls_config'
    require 'spectre_config'

    require 'outline'.setup {}

    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    alpha.setup(dashboard.config)

    require 'trouble'.setup {}
    vim.api.nvim_set_keymap('n', '<leader>td', ':Trouble diagnostics<CR>',
        { noremap = true, silent = true, desc = 'Trouble diagnostics' })

    vim.o.foldcolumn = '1' -- Указывает, сколько колонок отводить под индикаторы сворачивания
    vim.o.foldlevel = 99   -- Уровень сворачивания (99 означает, что код изначально не свернут)
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    require 'ufo'.setup {
        close_fold_kinds_for_ft = {
            default = { 'imports', 'comment' },
            json = { 'array' }
        },
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end
    }
    require 'nvim-autopairs'.setup {
        --disable_filetype = { 'TelescopePrompt' , 'vim' },
    }
    require 'Comment'.setup {}
    require 'bufferline'.setup {}
    require 'lualine'.setup {
        -- options = {
        --     theme = 'catppuccin'
        -- },
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

    local notify = require 'notify'
    vim.notify = notify
    notify.setup {
        max_width = 50,
        max_height = 60,
        render = 'wrapped-default'
    }

    -- ???
    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = {
    --         "dap-repl",
    --         "dapui_scopes",
    --         "dapui_console",
    --         "dapui_breakpoints",
    --         "dapui_stacks",
    --         "dapui_watches",
    --         "NvimTree",
    --         "spectre_panel",
    --         "codecompanion",
    --         "aerial",
    --         "trouble"
    --     },
    --     callback = function()
    --         vim.opt_local.winfixbuf = true
    --     end,
    -- })
end

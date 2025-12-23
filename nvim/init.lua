vim.cmd('syntax enable')
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.opt.termguicolors = true
vim.opt.exrc = true
vim.opt.secure = true
vim.diagnostic.config({
    virtual_text = true
})

local map = vim.keymap.set

map('n', '<S-Tab>', ':bprevious<CR>', { silent = true, desc = 'Previous buffer' })
map('n', '<Tab>', ':bnext<CR>', { silent = true, desc = 'Next buffer' })
map('n', '<leader>ga', ':!git add %<CR>', { desc = 'Git add buffer' })

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.opt_local.bufhidden = "wipe"
        vim.opt_local.buflisted = false
    end,
})

map("n", "<leader>q", function()
    local is_last_win = (vim.fn.winnr("$") == 1)

    if vim.bo.buftype == "terminal" then
        if is_last_win then
            vim.cmd("q")
        else
            vim.cmd("close")
        end
        return
    end

    vim.cmd("bd")
end, { desc = 'Close buffer or quit' })



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

require 'lazy'.setup {
    defaults = {
        lazy = true,
    },
    -- { import = 'plugins.codecompanion' },
    -- { import = 'plugins.dap' },
    -- { import = 'plugins.git' },
    -- { import = 'plugins.jupyter' },
    -- { import = 'plugins.lsp' },
    -- { import = 'plugins.lualine' },
    -- { import = 'plugins.monokai' },
    -- { import = 'plugins.nvim-cmp' },
    -- { import = 'plugins.nvim-tree' },
    -- { import = 'plugins.telescope' },
    -- { import = 'plugins.treesitter' },
    { import = 'plugins' },
    -- {
    --     "yorumicolors/yorumi.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd("colorscheme yorumi")
    --     end
    -- },
    {
        'nvim-tree/nvim-web-devicons',
        opts = {}
    },
    {
        'akinsho/bufferline.nvim',
        event = "BufReadPre",
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                sort_by = "id",
            },
        },
        keys = {
            { "<A-l>", "<cmd>BufferLineMoveNext<CR>", desc = "BufferLine: move buffer right" },
            { "<A-h>", "<cmd>BufferLineMovePrev<CR>", desc = "BufferLine: move buffer left" },
        },
    },
    {
        'folke/which-key.nvim',
        opts = {
            layout = {
                height = { min = 4, max = 80 },
                width = { min = 20, max = 100 },
                spacing = 4,
                align = "left",
                columns = 6,
            }
        }
    },
    {
        "MaximilianLloyd/ascii.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        'goolord/alpha-nvim',
        dependencies = { "MaximilianLloyd/ascii.nvim" },
        config = function()
            local alpha = require('alpha')
            local dashboard = require('alpha.themes.dashboard')
            local ascii = require('ascii')

            dashboard.section.header.val = ascii.art.text.neovim.sharp
            alpha.setup(dashboard.config)
        end,
    },
    {
        'rcarriga/nvim-notify',
        opts = {
            max_width = 50,
            max_height = 60,
            render = 'wrapped-default'
        },
        init = function()
            vim.notify = function(...)
                return require 'notify' (...)
            end
        end
    },
    {
        'stevearc/aerial.nvim',
        event = "BufRead",
        opts = {
            min_width = 50,
        }
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
    },
    {
        'zbirenbaum/copilot.lua',
        event = "InsertEnter",
        keys = {
            {
                '<leader>aP',
                '<cmd>Copilot panel<CR>',
                mode = 'n',
                desc = 'Open Copilot panel',
            }
        },
        opts = {
            filetypes = {
                markdown = true,
                yaml = true,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept_word = '<C-l>', -- Accept suggestion with <C-l>
                }
            }
        }
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.nvim",
        },
        ft = { "markdown", "codecompanion" },
        opts = {}
    },
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'folke/trouble.nvim',
        opts = {},
        keys = {
            { '<leader>td', ':Trouble diagnostics<CR>', desc = 'Toggle Trouble' }
        }
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {
            modes = {
                search = {
                    enabled = true,
                }
            }
        },
        keys = {
            {
                '<leader>sj',
                function()
                    require('flash').jump()
                end,
                mode = { 'n', 'x', 'o' },
                desc = 'Flash jump',
            },
            {
                '<leader>st',
                function()
                    require('flash').treesitter()
                end,
                mode = { 'n', 'x', 'o' },
                desc = 'Flash Treesitter',
            },
            {
                'r',
                function()
                    require('flash').remote()
                end,
                mode = 'o',
                desc = 'Remote Flash',
            },
            {
                '<leader>sts',
                function()
                    require('flash').treesitter_search()
                end,
                mode = { 'o', 'x' },
                desc = 'Flash Treesitter Search',
            },
            {
                '<c-s>',
                function()
                    require('flash').toggle()
                end,
                mode = 'c',
                desc = 'Toggle Flash Search',
            },
        }

    },
    {
        'nvim-pack/nvim-spectre',
        keys = {
            {
                '<leader>S',
                function()
                    require('spectre').toggle()
                end,
                mode = 'n',
                desc = 'Toggle Spectre',
            },
            {
                '<leader>sw',
                function()
                    require('spectre').open_visual(vim.fn.mode() == 'v' and { select_word = true } or {})
                end,
                mode = { 'n', 'v' },
                desc = 'Search current word',
            },
            {
                '<leader>sp',
                function()
                    require('spectre').open_file_search { select_word = true }
                end,
                mode = 'n',
                desc = 'Search on current file',
            },

        }
    },
    {
        'windwp/nvim-autopairs',
        opts = {}
    },
    {
        "kylechui/nvim-surround",
        version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async',
        },
        event = 'BufReadPost',
        opts = {
            close_fold_kinds_for_ft = {
                default = { 'imports', 'comment' },
                json = { 'array' },
            },
            provider_selector = function()
                return { 'treesitter', 'indent' }
            end,
        },
        init = function()
            vim.o.foldcolumn = '1' -- Колонки под индикаторы сворачивания
            vim.o.foldlevel = 99   -- 99 означает, что код изначально не свернут
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
    },
}

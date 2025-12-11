vim.cmd('syntax enable')
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.opt.termguicolors = true

local map = vim.keymap.set

map('n', '<S-Tab>', ':bprevious<CR>', { silent = true, desc = 'Previous buffer' })
map('n', '<Tab>', ':bnext<CR>', { silent = true, desc = 'Next buffer' })
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

require 'lazy'.setup {
    defaults = {
        lazy = true,
    },
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
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {}
    },
    {
        'folke/which-key.nvim',
        opts = {
            layout = {
                height = { min = 4, max = 80 },
                width = { min = 20, max = 100 },
                spacing = 4,
                align = "left",
                columns = 6, -- ⚡️ Показать до 4 колонок!
            }
        }
    },
    {
        'goolord/alpha-nvim',
        opts = require 'alpha.themes.dashboard'.config
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

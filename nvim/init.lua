vim.cmd('syntax enable')
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
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

require 'lazy'.setup {
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
        opts = {}
    },
    {
        'goolord/alpha-nvim',
        opts = require 'alpha.themes.dashboard'.config
    },
    {
        'j-hui/fidget.nvim',
        opts = {
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
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            local n = require 'notify'
            vim.notify = n
            n.setup {
                max_width = 50,
                max_height = 60,
                render = 'wrapped-default'
            }
        end,
    },
    {
        'stevearc/aerial.nvim',
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
            f.setup {
                modes = {
                    search = {
                        enabled = true
                    }
                }
            }
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
            spectre.setup {}
            map('n', '<leader>S', spectre.toggle, { desc = 'Toggle Spectre' })
            map({ 'n', 'v' }, '<leader>sw', function()
                spectre.open_visual(vim.fn.mode() == 'v' and { select_word = true } or {})
            end, { desc = 'Search current word' })
            map('n', '<leader>sp', function() spectre.open_file_search { select_word = true } end,
                { desc = 'Search on current file' })
        end,
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

            require 'ufo'.setup {
                close_fold_kinds_for_ft = {
                    default = { 'imports', 'comment' },
                    json = { 'array' }
                },
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end
            }
        end
    }
}

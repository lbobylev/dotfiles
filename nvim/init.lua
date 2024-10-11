-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Set line numbers
vim.opt.number = true

-- Set tab and indentation options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Initialize plugin manager
vim.cmd('packadd packer.nvim')

require 'packer'.startup(function(use)
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-jdtls'
    use 'nvim-neotest/nvim-nio'
    use 'rcarriga/nvim-dap-ui'
    use 'rcarriga/nvim-notify' -- optional dependency for folke/noice.nvim
    use 'j-hui/fidget.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'lewis6991/gitsigns.nvim'
    use { 'akinsho/bufferline.nvim', tag = '*' }
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'kevinhwang91/promise-async'
    use 'kevinhwang91/nvim-ufo'
    -- use {'tzachar/cmp-tabnine', run = './install.sh'}
    use 'zbirenbaum/copilot.lua'
    use 'zbirenbaum/copilot-cmp'
    use { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' }
    use 'folke/trouble.nvim'
    use 'folke/which-key.nvim'
    use {
        'VonHeikemen/fine-cmdline.nvim',
        requires = {
            { 'MunifTanjim/nui.nvim' }
        }
    }
    use 'nvim-pack/nvim-spectre'
    use 'goolord/alpha-nvim'
    use 'echasnovski/mini.icons'
    use 'onsails/lspkind.nvim'
    use 'hedyhli/outline.nvim'
end)

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set colorscheme
vim.cmd('colorscheme catppuccin-mocha')

require 'copilot_config'
-- require 'noice_config'
require 'cmp_config'
require 'telescope_config'
require 'mason_config'
require 'gitsigns_config'
require 'nvim_tree_config'
require 'jdtl_config'
require 'spectre_config'

-- Настройка горячих клавиш для перемещения между буферами
-- Используем <A-...> для Option и <D-...> для Command
vim.api.nvim_set_keymap('n', '<leader>j', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
vim.api.nvim_set_keymap('n', '<leader>k', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })

require 'catppuccin'.setup {
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        --[[notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
        },]]
    }
}

require 'outline'.setup {}

local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
alpha.setup(dashboard.config)

require 'trouble'.setup {}
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble<CR>', { noremap = true, silent = true, desc = 'Trouble' })

vim.o.foldcolumn = '1' -- Указывает, сколько колонок отводить под индикаторы сворачивания
vim.o.foldlevel = 99   -- Уровень сворачивания (99 означает, что код изначально не свернут)
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require 'ufo'.setup {
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
}
require 'nvim-autopairs'.setup {
    --disable_filetype = { 'TelescopePrompt' , 'vim' },
}
require 'Comment'.setup {}
require('bufferline').setup {}
require 'lualine'.setup { options = { theme = 'catppuccin' } }

vim.keymap.set('n', '<leader>du', require 'dapui'.toggle, { desc = 'Toggle DAP UI' })
vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })
-- Key bindings for resizing windows
vim.api.nvim_set_keymap('n', '<leader><Up>', ':resize +5<CR>',
    { noremap = true, silent = true, desc = 'Increase window height' })
vim.api.nvim_set_keymap('n', '<leader><Down>', ':resize -5<CR>',
    { noremap = true, silent = true, desc = 'Decrease window height' })
vim.api.nvim_set_keymap('n', '<leader><Left>', ':vertical resize -5<CR>',
    { noremap = true, silent = true, desc = 'Decrease window width' })
vim.api.nvim_set_keymap('n', '<leader><Right>', ':vertical resize +5<CR>',
    { noremap = true, silent = true, desc = 'Increase window width' })
vim.keymap.set('n', '<leader>u', function()
    local modules_to_reload = {
        "copilot_config",
        "jdtl_config",
        "telescope_config",
    }
    for _, module in ipairs(modules_to_reload) do
        package.loaded[module] = nil
        return require(module)
    end
end, { noremap = true, silent = true, desc = 'Reload config' })

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


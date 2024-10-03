syntax enable
set number
set tabstop=4
set shiftwidth=4
set expandtab

call plug#begin()
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
  Plug 'numToStr/Comment.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'kevinhwang91/promise-async'
  Plug 'kevinhwang91/nvim-ufo'
  "Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Plug 'zbirenbaum/copilot.lua'
  Plug 'zbirenbaum/copilot-cmp'
  Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }
  Plug 'folke/trouble.nvim'
  Plug 'folke/which-key.nvim'
  Plug 'folke/noice.nvim' 
  Plug 'MunifTanjim/nui.nvim' "dependency for folks/noice.nvim
  Plug 'rcarriga/nvim-notify', "optional dependency for folks/noice.nvim
  Plug 'nvim-pack/nvim-spectre'
  Plug 'goolord/alpha-nvim'
  Plug 'echasnovski/mini.icons'
  Plug 'onsails/lspkind.nvim'
  Plug 'hedyhli/outline.nvim'
call plug#end()

let mapleader = ' '
let maplocalleader = ' '
colorscheme catppuccin-mocha " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

lua << EOF
require('config')
EOF

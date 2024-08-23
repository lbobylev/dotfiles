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
call plug#end()

colorscheme catppuccin-mocha " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

lua << EOF

require('nvim-autopairs').setup({
  --disable_filetype = { "TelescopePrompt" , "vim" },
})

require('Comment').setup()

require("bufferline").setup{}

require('telescope').setup({
  defaults = {
    path_display = {
      shorten = {
        len = 3, exclude = {1, -1}
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
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<space>ff', function()
    local src_dir = '/Users/leonid/src'
    local cwd = vim.fn.getcwd()
    local opts = {}
    if cwd == src_dir .. '/ewc-app-galvman'
        or cwd == src_dir .. '/ewc-app-eyedes'
        or cwd == src_dir .. '/ewc-app-eyeman' then
        opts = {
            search_dirs = {
                cwd,
                src_dir .. '/surge-app-core',
                src_dir .. '/front-app-core',
                src_dir .. '/front-app-ewc'
            }
        }
    end
    builtin.find_files(opts)
end, {})
vim.keymap.set('n', '<space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<space>fb', builtin.buffers, {})
vim.keymap.set('n', '<space>fh', builtin.help_tags, {})

require('telescope').load_extension('fzf')

require('lualine').setup {
  options = { theme = 'onedark' },
}

-- nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local tree_on_attach = function(bufnr)
    local api = require "nvim-tree.api"
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<space>th', api.tree.toggle_help)
end

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
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
})

vim.keymap.set('n', "<space>tt", "<cmd>NvimTreeToggle<cr>")

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    'tsserver',
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
    -- 'vimls'
  }
})

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  require('lsp_mappings').setup(bufnr)
end

require('mason-lspconfig').setup_handlers({
  function (server_name )
    if server_name == 'jdtls' then
        -- do nothing
    elseif server_name == 'efm' then
        local config = {{ formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true }}
        lspconfig.efm.setup {
            init_options = { documentFormatting = true },
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
            settings = {
              rootMarkers = { ".git/" },
              languages = {
                  typescript = config,
                  javascript = config, 
                  typescriptreact = config,
                  javascriptreact = config,
              }
            }
        }
        vim.cmd('command! -nargs=0 Prettier :lua vim.lsp.buf.format()')
        vim.cmd([[
          augroup FormatAutogroup
            autocmd!
            autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx Prettier
          augroup END
        ]])
    elseif server_name == 'tsserver' then
      lspconfig.tsserver.setup {
          on_attach = function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
              lsp_attach(client, bufnr)
          end,
          capabilities = lsp_capabilities
      }
    else
      lspconfig[server_name].setup({
          on_attach = lsp_attach,
          capabilities = lsp_capabilities
      })
    end
  end
})

local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
  },
  snippet = {
    expand = function(args) vim.fn["vsnip#anonymous"](args.body) -- because we are using the vsnip cmp plugin
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
}

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<space>hs', gitsigns.stage_hunk)
    map('n', '<space>hr', gitsigns.reset_hunk)
    map('v', '<space>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<space>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<space>hS', gitsigns.stage_buffer)
    map('n', '<space>hu', gitsigns.undo_stage_hunk)
    map('n', '<space>hR', gitsigns.reset_buffer)
    map('n', '<space>hp', gitsigns.preview_hunk)
    map('n', '<space>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<space>tb', gitsigns.toggle_current_line_blame)
    map('n', '<space>hd', gitsigns.diffthis)
    map('n', '<space>hD', function() gitsigns.diffthis('~') end)
    map('n', '<space>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}


EOF

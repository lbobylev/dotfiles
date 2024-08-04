-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local tree_on_attach = function(bufnr)
    local api = require 'nvim-tree.api'
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<leader>th', api.tree.toggle_help, { desc = 'Toggle NvimTree help' })
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

vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle NvimTree' })


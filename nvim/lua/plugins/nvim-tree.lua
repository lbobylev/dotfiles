local map = vim.keymap.set

return {
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
            on_attach = function(bufnr)
                local api = require 'nvim-tree.api'
                api.config.mappings.default_on_attach(bufnr)
                map('n', '<leader>th', api.tree.toggle_help, { desc = 'Toggle NvimTree help' })
            end
        }
        map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle NvimTree' })
    end,
}

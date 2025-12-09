return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    init = function()
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
        sort = {
            sorter = 'case_sensitive',
        },
        view = {
            width = 40,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = true,
        },
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        on_attach = function(bufnr)
            local api = require 'nvim-tree.api'
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set('n', '<leader>th', api.tree.toggle_help, {
                desc = 'Toggle NvimTree help',
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
            })
        end
    },
    keys = {
        { '<leader>tt', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle NvimTree' },
    }
}

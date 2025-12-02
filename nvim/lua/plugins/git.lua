local map = vim.keymap.set

return {
    {
        'akinsho/git-conflict.nvim',
        version = '*',
        dependencies = {
            'onsails/lspkind.nvim'
        },
        config = function()
            require 'git-conflict'.setup {}
            map('n', '<leader>cn', '<Plug>(git-conflict-next-conflict)', { desc = 'Go to next conflict' })
            map('n', '<leader>cp', '<Plug>(git-conflict-prev-conflict)', { desc = 'Go to previous conflict' })
            map('n', '<leader>cb', '<Plug>(git-conflict-choose-both)', { desc = 'Choose both changes' })
            map('n', '<leader>ct', '<Plug>(git-conflict-theirs)', { desc = 'Choose their changes' })
            map('n', '<leader>co', '<Plug>(git-conflict-ours)', { desc = 'Choose our changes' })
        end,

    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function()
                map('n', '<leader>gh', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
                map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle current line blame' })
            end
        }
    },
    {
        'linrongbin16/gitlinker.nvim',
        opts = {}
    },
}

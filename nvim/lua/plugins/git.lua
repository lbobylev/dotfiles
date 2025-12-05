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
            map('n', '<leader>cn', ':GitConflictNextConflict<CR>', { desc = 'Go to next conflict' })
            map('n', '<leader>cp', ':GitConflictNextConflict<CR>', { desc = 'Go to previous conflict' })
            map('n', '<leader>cb', ':GitConflictChooseBoth<CR>', { desc = 'Choose both changes' })
            map('n', '<leader>ct', ':GitConflictChooseTheirs<CR>', { desc = 'Choose their changes' })
            map('n', '<leader>co', ':GitConflictChooseOurs<CR>', { desc = 'Choose our changes' })
        end,

    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function()
                map('n', '<leader>gh', ':Gitsigns preview_hunk_inline<CR>', { desc = 'Preview hunk' })
                map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle current line blame' })
                map('n', '<leader>gd', ':Gitsigns diffthis<CR>', { desc = 'Diff this' })
            end
        }
    },
    {
        'linrongbin16/gitlinker.nvim',
        opts = {}
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        config = function()
            vim.g.lazygit_floating_window_scaling_factor = 1
        end,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    }
}

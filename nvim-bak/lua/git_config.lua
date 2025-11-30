local function map(mode, lhs, rhs, desc)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

require 'gitsigns'.setup { on_attach = function(bufnr)
        map('n', '<leader>gh', ':Gitsigns preview_hunk<CR>', 'Preview hunk')
        map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', 'Toggle current line blame')
    end
}

require 'git-conflict'.setup()
map('n', '<leader>cn', '<Plug>(git-conflict-next-conflict)', 'Go to next conflict')
map('n', '<leader>cp', '<Plug>(git-conflict-prev-conflict)', 'Go to previous conflict')
map('n', '<leader>cb', '<Plug>(git-conflict-choose-both)', 'Choose both changes')
map('n', '<leader>ct', '<Plug>(git-conflict-theirs)', 'Choose their changes')
map('n', '<leader>co', '<Plug>(git-conflict-ours)', 'Choose our changes')


map('n', '<leader>ga', ':!git add %<CR>', 'Git add buffer')

require 'gitlinker'.setup {}

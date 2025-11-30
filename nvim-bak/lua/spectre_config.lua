-- search and replace
local spectre = require 'spectre'
spectre.setup {
    default = {
        replace = {
            cmd = 'sd'
        }
    }
}
vim.keymap.set('n', '<leader>S', spectre.toggle, { desc = 'Toggle Spectre' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', function()
    spectre.open_visual(vim.fn.mode() == 'v' and { select_word = true } or {})
end, { desc = 'Search current word' })
vim.keymap.set('n', '<leader>sp', function() spectre.open_file_search { select_word = true } end,
    { desc = 'Search on current file' })

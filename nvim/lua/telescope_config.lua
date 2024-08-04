local telescope = require 'telescope'

telescope.setup {
    defaults = {
        path_display = {
            shorten = {
                len = 3, exclude = { 1, -1 }
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
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = 'smart_case',       -- or 'ignore_case' or 'respect_case'
        }
    }
}

local get_opts = function()
    local src_dir = '/Users/leonid/src'
    local cwd = vim.fn.getcwd()
    if string.match(cwd, '^' .. src_dir .. '/ewc%-app%-.+$') then
        return {
            search_dirs = { cwd, src_dir .. '/surge-app-unified' }
        }
    elseif string.match(cwd, '^' .. src_dir .. '/ewc%-web%-.+$') then
        return {
            search_dirs = {
                cwd,
                src_dir .. '/front-pkg-core',
                src_dir .. '/front-pkg-catalog',
                src_dir .. '/front-pkg-dam'
            }
        }
    end
    return {}
end

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', function() builtin.find_files(get_opts()) end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(get_opts()) end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fn', '<cmd>:Telescope notify<CR>', { desc = 'Notify history' })

telescope.load_extension 'fzf'
-- telescope.load_extension 'noice'

-- monokai background color
vim.cmd [[highlight TelescopeNormal guibg=#000000]]

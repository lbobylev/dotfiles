local map = vim.keymap.set

return {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
    },
    config = function()
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
            local src_dir = vim.fn.expand('~/src')
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
        map('n', '<leader>ff', function() builtin.find_files(get_opts()) end, { desc = 'Find files' })
        map('n', '<leader>fg', function() builtin.live_grep(get_opts()) end, { desc = 'Live grep' })
        map('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
        map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
        map('n', '<leader>fn', '<cmd>Telescope notify<CR>', { desc = 'Notify history' })
        map("n", "<leader>fr", builtin.resume, { desc = 'Telescope resume' })

        telescope.load_extension 'fzf'
    end
}

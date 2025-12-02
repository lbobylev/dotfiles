return {
    'olimorris/codecompanion.nvim',
    version = 'v17.33.0',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        'tpope/vim-fugitive',
        'echasnovski/mini.diff',
        'echasnovski/mini.icons'
    },
    config = function()
        local adapters = require 'codecompanion.adapters'

        require 'codecompanion'.setup {
            strategies = {
                chat = { adapter = 'openai' },
                inline = { adapter = 'openai' }
            },
            adapters = {
                http = {
                    openai = function()
                        return adapters.extend('openai', {
                            env = {
                                api_key = 'OPENAI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'gpt-5.1',
                                    temperature = 0,
                                }
                            }
                        })
                    end
                }
            },
            display = {
                chat = {
                    render_headers = false,
                    window = {
                        layout = 'horizontal',
                        width = 1,
                        height = 0.4,
                    }
                },
                diff = {
                    provider = 'mini_diff',
                    layout = 'horizontal',
                }
            }
        }

        require 'codecompanion-fidget-spinner':init()

        vim.api.nvim_set_keymap('v', "<leader>aa", "<cmd>CodeCompanionActions<cr>",
            { noremap = true, silent = true, desc = 'Code Companion - Actions' })
        vim.api.nvim_set_keymap('n', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
            { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
        vim.api.nvim_set_keymap('v', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
            { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
        vim.api.nvim_set_keymap('v', "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",
            { noremap = true, silent = true, desc = 'Code Companion - Chat add' })

        -- Expand 'cc' into 'CodeCompanion' in the command line
        vim.cmd([[cab cc CodeCompanion]])
    end
}

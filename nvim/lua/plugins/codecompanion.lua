return {
    {
        "echasnovski/mini.diff",
        version = false,
        config = function()
            local diff = require("mini.diff")
            diff.setup({
                -- по умолчанию отключаем git-дифф как источник,
                -- CodeCompanion сам переключит источник, когда нужно
                source = diff.gen_source.none(),
            })
        end,
    },
    {
        'olimorris/codecompanion.nvim',
        event = 'VeryLazy',
        version = 'v17.33.0',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            'tpope/vim-fugitive',
            'echasnovski/mini.diff',
            'echasnovski/mini.icons'
        },
        init = function()
            -- vim.g.codecompanion_auto_tool_mode = true
            require 'codecompanion-fidget-spinner':init()
            -- Expand 'cc' into 'CodeCompanion' in the command line
            vim.cmd([[cab cc CodeCompanion]])
        end,
        keys = {
            {
                "<leader>aa",
                "<cmd>CodeCompanionActions<cr>",
                mode = "v",
                desc = "Code Companion - Actions",
                noremap = true,
                silent = true,
            },
            {
                "<leader>at",
                "<cmd>CodeCompanionChat Toggle<cr>",
                mode = "n",
                desc = "Code Companion - Toggle chat",
                noremap = true,
                silent = true,
            },
            {
                "<leader>ad",
                "<cmd>CodeCompanionChat Add<cr>",
                mode = "v",
                desc = "Code Companion - Chat add",
                noremap = true,
                silent = true,
            },

        },
        opts = {
            strategies = {
                chat = { adapter = 'openai' },
                inline = {
                    adapter = 'openai',
                }
            },
            adapters = {
                http = {
                    openai = function()
                        return require 'codecompanion.adapters'.extend('openai', {
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
                -- diff = {
                --     provider = 'mini_diff',
                -- },
                -- inline = {
                --     layout = "buffer"
                -- },
            }
        }
    }
}

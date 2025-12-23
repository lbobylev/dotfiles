return {
    -- {
    --     "echasnovski/mini.diff",
    --     version = false,
    --     config = function()
    --         local diff = require("mini.diff")
    --         diff.setup({
    --             source = diff.gen_source.none(),
    --         })
    --     end,
    -- },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            "tpope/vim-fugitive",
            "echasnovski/mini.diff",
            "echasnovski/mini.icons",
        },
        init = function()
            require("codecompanion-fidget-spinner"):init()
            vim.cmd([[cab cc CodeCompanion]])

            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    if vim.bo.filetype == "codecompanion" or vim.b.codecompanion then
                        vim.wo.winfixbuf = true
                    end
                end,
            })
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
            interactions = {
                chat = {
                    adapter = "openai",
                    opts = {
                        system_prompt = function(ctx)
                            return ctx.default_system_prompt
                        end,
                        override_system_prompt = true,
                    },
                },
                inline = { adapter = "openai" },
            },

            adapters = {
                http = {
                    openai = function()
                        return require("codecompanion.adapters").extend("openai", {
                            env = { api_key = "OPENAI_API_KEY" },
                            schema = {
                                model = { default = "gpt-5.1" },
                            },
                            parameters = {
                                temperature = 0,
                            },
                        })
                    end,
                },
            },

            display = {
                chat = {
                    render_headers = false,
                    window = {
                        layout = "horizontal",
                        width = 1,
                        height = 0.4,
                    },
                },
            },
        },
    }

}

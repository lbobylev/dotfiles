require 'copilot'.setup {
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept_word = '<C-l>', -- Accept suggestion with <C-l>
        }
    }
}

vim.keymap.set({ 'n', 'v' }, '<leader>aP', require 'copilot.panel'.open, { desc = 'Copilot - Panel' })

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function get_password(entry)
    local file = io.open('/Users/leonid/.' .. entry, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return trim(content)
    else
        return nil
    end
end

local openai_key = get_password 'openai'
local anthropic_key = get_password 'anthropic'
local gemini_key = get_password 'gemini'

local adapters = require 'codecompanion.adapters'
require 'codecompanion'.setup {
    strategies = {
        chat = { adapter = 'gemini' },
        inline = { adapter = 'openai' }
    },
    adapters = {
        ollama = function()
            return adapters.extend('ollama', {
                name = 'llama3',
                schema = {
                    model = {
                        default = 'llama3.1:latest',
                    },
                    num_ctx = {
                        default = 16384,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
        openai = function()
            return adapters.extend('openai', {
                env = {
                    api_key = openai_key
                },
                schema = {
                    model = {
                        default = 'gpt-4o'
                    }
                }
            })
        end,
        gemini = function()
            return adapters.extend('gemini', {
                env = {
                    api_key = gemini_key
                },
                schema = {
                    model = {
                        -- gemini-2.5-pro-exp-03-25
                        -- gemini-2.0-flash
                        -- gemini-2.0-pro-exp-02-05
                        -- gemini-1.5-flash
                        -- gemini-1.5-pro
                        -- gemini-1.0-pro
                        default = 'gemini-2.5-pro-preview-05-06'
                    }
                }
            })
        end,
        anthropic = function()
            return adapters.extend("anthropic", {
                env = {
                    api_key = anthropic_key
                },
                schema = {
                    model = {
                        default = "claude-3-5-sonnet-latest"
                        -- default = "claude-3-5-haiku-latest"
                    }
                }
            })
        end,
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

require 'plugins.codecompanion.fidget-spinner':init()

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

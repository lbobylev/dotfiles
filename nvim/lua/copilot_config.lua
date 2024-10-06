require 'copilot'.setup {
    panel = {
        auto_refresh = true
    }
}

local copilot_chat = require 'CopilotChat'

copilot_chat.setup {
    prompts = {
        -- Refactor = {
        --     prompt = 'Refactor the following code to improve readability and maintainability. Please ensure that the code follows best practices and optimizes performance where possible. Add comments where necessary to explain complex logic.'
        -- }
    },
    context = 'buffers',
    debug = true, -- Enable debugging
    show_help = 'yes',
    mappings = {
        complete = {
            insert = ''
        }
    },
    window = {
        layout = 'float',
        relative = 'cursor',
        width = 1,
        height = .8,
        row = 1
    }
}

local selection_context = vim.fn.mode() == 'v' and { 'visual', 'buffers' } or 'buffers'
local select = require 'CopilotChat.select'

vim.keymap.set({ 'n', 'v' }, '<leader>ac', function()
    local input = vim.fn.input('Copilot: ')
    if input ~= '' then
        copilot_chat.ask(input, {
            selection = select[selection_context]
        })
    end
end, { desc = 'Copilot - Chat' })

vim.keymap.set({ 'n', 'v' }, '<leader>ai', function()
    copilot_chat.ask(
        'Refactor the following code to improve readability and maintainability. Please ensure that the code follows best practices and optimizes performance where possible. Add comments where necessary to explain complex logic.',
        {
            selection = select[selection_context]

        })
end, { desc = 'Copilot - Refactor' })

vim.keymap.set('n', '<leader>ar', function() copilot_chat.reset() end, { desc = 'Copilot - Reset Chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>ae', '<cmd>CopilotChatExplain<cr>', { desc = 'Copilot - Explain' })
vim.keymap.set({ 'n', 'v' }, '<leader>af', '<cmd>CopilotChatFix<cr>', { desc = 'Copilot - Fix' })
vim.keymap.set({ 'n', 'v' }, '<leader>ap', function() require 'copilot.panel'.open() end, { desc = 'Copilot - Panel' })

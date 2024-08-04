require 'copilot'.setup {
    suggestion = {
        auto_trigger = true
    },
    panel = {
        enable = true,
        auto_refresh = true
    }
}

vim.keymap.set({ 'n', 'v' }, '<leader>aP', require 'copilot.panel'.open, { desc = 'Copilot - Panel' })

-- local copilot_chat = require 'CopilotChat'
-- local select = require 'CopilotChat.select'
--
-- copilot_chat.setup {
--     prompts = {
--         -- Refactor = {
--         --     prompt = 'Refactor the following code to improve readability and maintainability. Please ensure that the code follows best practices and optimizes performance where possible. Add comments where necessary to explain complex logic.'
--         -- },
--     },
--     context = 'buffers',
--     debug = true, -- Enable debugging
--     show_help = 'yes',
--     mappings = {
--         complete = {
--             insert = ''
--         }
--     },
--     -- window = {
--     --     layout = 'float',
--     --     relative = 'cursor',
--     --     width = 1,
--     --     height = .8,
--     --     row = 1
--     -- }
-- }
--
-- local function ask(text, prompt)
--     local input = vim.fn.input(text .. ': ')
--     if input ~= '' then
--         copilot_chat.ask(input .. ' ' .. prompt, {
--             selection = select[vim.fn.mode() == 'v' and 'visual' or 'buffer'],
--             context = 'buffers'
--         })
--     end
-- end

-- vim.keymap.set({ 'n', 'v' }, '<leader>an', function() ask('Ask Copilot', '') end, { desc = 'Copilot - New Chat' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>apr', function()
--     copilot_chat.ask('Refactor the following code to improve readability and maintainability. '
--         .. 'Please ensure that the code follows best practices and optimizes performance where possible. '
--         .. 'Add comments where necessary to explain complex logic.', {
--             selection = select[vim.fn.mode() == 'v' and 'visual' or 'buffer']
--         })
-- end, { desc = 'Copilot - Refactor' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>apt', function()
--     copilot_chat.ask('/Tests', { selection = select[vim.fn.mode() == 'v' and 'visual' or 'buffer'] })
-- end, { desc = 'Copilot - Tests' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>apq', function()
--     ask('Q&A',
--         'Please ask me a series of specific yes/no questions to '
--         .. 'gather more information and provide a more accurate recommendation.')
-- end, { desc = 'Copilot - Q&A Strategy' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>app', function()
--     ask('Pros and Cons', 'Give me the pros and cons of each approach.')
-- end, { desc = 'Copilot - Pros and Cons Strategy' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>aps', function()
--     ask('Stepwise Chain of Thought', 'Go one step at a time. '
--         .. 'Do not move to the next step until I give the keyword "next". Begin.')
-- end, { desc = 'Copilot - Stepwise Chain of Thought Strategy' })
--
-- vim.keymap.set({ 'n', 'v' }, '<leader>ape', '<cmd>CopilotChatExplain<cr>', { desc = 'Copilot - Explain' })
-- vim.keymap.set({ 'n', 'v' }, '<leader>apf', '<cmd>CopilotChatFix<cr>', { desc = 'Copilot - Fix' })
-- vim.keymap.set({ 'n', 'v' }, '<leader>at', copilot_chat.toggle, { desc = 'Copilot - Toggle Chat' })
-- vim.keymap.set('n', '<leader>ar', copilot_chat.reset, { desc = 'Copilot - Reset Chat' })

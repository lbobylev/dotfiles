local M = {}

local function map(mode, key, action, desc)
    vim.keymap.set(mode, key, action, { noremap = true, silent = true, desc = desc })
end

M.setup = function(bufnr)
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gr', vim.lsp.buf.references, 'Find references')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', '<leader>h', vim.lsp.buf.hover, 'Hover documentation')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code actions')
    map({ 'n', 'v' }, '<leader>f', vim.lsp.buf.format, 'Format code')


    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', unpack(opts) })
    -- vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, { desc = 'Signature help', unpack(opts) })
    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder', unpack(opts) })
    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
    --     { desc = 'Remove workspace folder', unpack(opts) })
    -- vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    --     { desc = 'List workspace folders', unpack(opts) })
    -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Go to type definition', unpack(opts) })
end

return M

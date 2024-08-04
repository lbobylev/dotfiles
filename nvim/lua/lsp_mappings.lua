local M = {}

M.setup = function(bufnr)
    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', unpack(opts) })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', unpack(opts) })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation', unpack(opts) })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references', unpack(opts) })
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { desc = 'Hover documentation', unpack(opts) })
    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, { desc = 'Signature help', unpack(opts) })
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder', unpack(opts) })
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
        { desc = 'Remove workspace folder', unpack(opts) })
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        { desc = 'List workspace folders', unpack(opts) })
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Go to type definition', unpack(opts) })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol', unpack(opts) })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions', unpack(opts) })
    vim.keymap.set({ 'n', 'v' }, '<leader>f', function() vim.lsp.buf.format { async = true, buffer = bufnr } end,
        { desc = 'Format code', unpack(opts) })
end

return M

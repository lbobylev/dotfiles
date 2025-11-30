local M = {}

function M.nnoremap(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end

local lsp = vim.lsp
---@diagnostic disable-next-line: deprecated
local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients

---@return string?, vim.lsp.Client?
local function extract_data_dir(bufnr)
    -- Prefer client from current buffer, in case there are multiple jdtls clients (multiple projects)
    local client = get_clients({ name = "jdtls", bufnr = bufnr })[1]
    if not client then
        -- Try first matching jdtls client otherwise. In case the user is in a
        -- different buffer like the quickfix list
        local clients = get_clients({ name = "jdtls" })
        if vim.tbl_count(clients) > 1 then
            ---@diagnostic disable-next-line: cast-local-type
            client = require 'jdtls.ui'.pick_one(
                clients,
                'Multiple jdtls clients found, pick one: ',
                function(c) return c.config.root_dir end
            )
        else
            client = clients[1]
        end
    end

    if client and client.config and client.config.cmd then
        local cmd = client.config.cmd
        if type(cmd) == "table" then
            for i, part in pairs(cmd) do
                -- jdtls helper script uses `--data`, java jar command uses `-data`.
                if part == '-data' or part == '--data' then
                    return client.config.cmd[i + 1], client
                end
            end
        end
    end

    return nil, nil
end

function M.wipe_data_and_restart()
    local data_dir, client = extract_data_dir(vim.api.nvim_get_current_buf())
    if not data_dir or not client then
        vim.notify(
            "Data directory wasn't detected. " ..
            "You must call `start_or_attach` at least once and the cmd must include a `-data` parameter (or `--data` if using the official `jdtls` wrapper)")
        return
    end
    vim.schedule(function()
        local bufs = vim.lsp.get_buffers_by_client_id(client.id)
        client.stop()
        vim.wait(30000, function()
            return vim.lsp.get_client_by_id(client.id) == nil
        end)
        vim.fn.delete(data_dir, 'rf')
        local client_id
        if vim.bo.filetype == "java" then
            client_id = lsp.start(client.config)
        else
            client_id = vim.lsp.start_client(client.config)
        end
        if client_id then
            for _, buf in ipairs(bufs) do
                lsp.buf_attach_client(buf, client_id)
            end
        end
    end)
end

return M

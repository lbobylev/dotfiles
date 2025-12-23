return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local tt = require "toggleterm"

        tt.setup({
            open_mapping = [[<C-\>]],
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            hide_numbers = true,
            shade_terminals = false,
            persist_size = true,
            close_on_exit = true,
            direction = "float", -- default
            float_opts = {
                -- border = "rounded",
            },
        })

        -- Esc → normal mode
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

        vim.keymap.set("n", "<leader>th", function()
            tt.toggle(1, 10, vim.loop.cwd(), "horizontal")
        end, { desc = "Terminal horizontal" })
    end,
}

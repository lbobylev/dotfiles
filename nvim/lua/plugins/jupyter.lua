return {
    {
        '3rd/image.nvim',
        ft = { 'markdown' },
        opts = {
            backend = 'kitty',
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
        },
    },
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        ft = { "markdown", "python" },
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
            vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python3")

            vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten" })
            vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { desc = "Run Line in Molten" })
            vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
                { desc = "Run Selection in Molten" })
            vim.keymap.set("n", "<localleader>mk", ":MoltenInterrupt<CR>", { desc = "Interrupt Molten" })
            vim.keymap.set("n", "<localleader>mr", ":MoltenRestart<CR>", { desc = "Restart Molten" })

            vim.api.nvim_create_user_command("MoltenRunPythonBlock", function()
                local cur_line = vim.fn.line(".")
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

                local start_line = nil
                for i = cur_line, 1, -1 do
                    if lines[i]:match("^```python") then
                        start_line = i
                        break
                    end
                end
                if not start_line then
                    print("Not inside a ```python block")
                    return
                end

                local end_line = nil
                for i = start_line + 1, #lines do
                    if lines[i]:match("^```%s*$") then
                        end_line = i
                        break
                    end
                end
                if not end_line or end_line <= start_line + 1 then
                    print("Closing ``` not found or block is empty")
                    return
                end

                vim.fn.MoltenEvaluateRange(start_line + 1, end_line - 1)
            end, { desc = "Run current python block with Molten" })

            vim.keymap.set("n", "<localleader>rb", ":MoltenRunPythonBlock<CR>",
                { desc = "Run current python block in Molten" })

            vim.keymap.set("n", "<localleader>eo", function()
                vim.cmd("noautocmd MoltenEnterOutput")
                vim.bo.filetype = "markdown"
            end, { desc = "Enter output" })
        end,
    },
    {
        "GCBallesteros/jupytext.nvim",
        opts = {
            style = "hydrogen",
            output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
            force_ft = nil,            -- Default filetype. Don't change unless you know what you are doing
            custom_language_formatting = {
                python = {
                    extension = "md",
                    style = "markdown",
                    force_ft = "markdown", -- you can set whatever filetype you want here
                },
                --     python = {
                --         extension = "qmd",
                --         style = "quarto",
                --         force_ft = "quarto", -- you can set whatever filetype you want here
                --     },
            },
        }
    }
}

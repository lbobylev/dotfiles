local gitsigns = require 'gitsigns'

gitsigns.setup {
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage current hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset current hunk' })
        map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'Stage selected hunk' })
        map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'Reset selected hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage entire buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset entire buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>hb', function()
            gitsigns.blame_line { full = true }
        end, { desc = 'Blame current line (full)' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff current buffer' })
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = 'Diff against last commit' })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted lines' })
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end
}

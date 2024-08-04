local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
end

local cmp = require 'cmp'
local compare = require 'cmp.config.compare'

cmp.setup {
    sources = {
        -- { name = 'cmp_tabnine' },
        -- { name = 'copilot',                group_index = 2 },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vsnip' },
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            -- require 'cmp_tabnine.compare',
            -- require 'copilot_cmp.comparators'.prioritize,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
 q       },
    },
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body) -- because we are using the vsnip cmp plugin
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- Ctrl + d
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        -- https://github.com/zbirenbaum/copilot-cmp?tab=readme-ov-file#tab-completion-configuration-highly-recommended
        ['<Tab>'] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     else
        --         fallback()
        --     end
        -- end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback) -- Shift + Tab
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    formatting = {
        format = require 'lspkind'.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            symbol_map = { Copilot = '' },
            maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                if entry.source.name == 'cmp_tabnine' then
                    vim_item.kind = '🚀'
                    vim_item.menu = 'Tabnine'
                end
                return vim_item
            end
        })
    }
}

-- require 'copilot_cmp'.setup()
-- vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
-- require 'CopilotChat.integrations.cmp'.setup()

-- require('cmp_tabnine.config'):setup({
--     max_lines = 1000,
--     max_num_results = 20,
--     sort = true,
--     run_on_every_keystroke = true,
--     snippet_placeholder = '..',
--     ignored_file_types = {
--         -- default is not to ignore
--         -- uncomment to ignore in lua:
--         -- lua = true
--     },
--     show_prediction_strength = false,
--     min_percent = 0
-- })
-- -- ??? doesn't work with lspkind
-- vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#6CC644" })
-- local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
-- vim.api.nvim_create_autocmd('BufRead', {
--     group = prefetch,
--     pattern = { '*.py', '*.lua', '*.java', '*.ts', '*.tsx', '*.js', '*.jsx' },
--     callback = function()
--         require('cmp_tabnine'):prefetch(vim.fn.expand('%:p'))
--     end
-- })

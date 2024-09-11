require("catppuccin").setup({
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        --[[notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
        },]]
    }
})

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

alpha.setup(dashboard.config)

require('spectre').setup({})
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    { desc = "Search current word" })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    { desc = "Search on current file" })

require('trouble').setup({})
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble<CR>', { noremap = true, silent = true, desc = 'Trouble' })

require('cmp_tabnine.config'):setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
    ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
    },
    show_prediction_strength = false,
    min_percent = 0
})
-- ??? doesn't work with lspkind
vim.api.nvim_set_hl(0, "CmpItemKindTabNine", { fg = "#6CC644" })
local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
vim.api.nvim_create_autocmd('BufRead', {
    group = prefetch,
    pattern = { '*.py', '*.lua', '*.java', '*.ts', '*.tsx', '*.js', '*.jsx' },
    callback = function()
        require('cmp_tabnine'):prefetch(vim.fn.expand('%:p'))
    end
})

vim.o.foldcolumn = '1' -- Указывает, сколько колонок отводить под индикаторы сворачивания
vim.o.foldlevel = 99   -- Уровень сворачивания (99 означает, что код изначально не свернут)
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})

require('nvim-autopairs').setup({
    --disable_filetype = { "TelescopePrompt" , "vim" },
})

require('Comment').setup()

require("bufferline").setup {}

require('telescope').setup({
    defaults = {
        path_display = {
            shorten = {
                len = 3, exclude = { 1, -1 }
            },
            truncate = true
        },
        dynamic_preview_title = true,
    },
    pickers = {
        find_files = { no_ignore = false, hidden = false }
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
    }
})

local get_opts = function()
    local src_dir = '/Users/leonid/src'
    local cwd = vim.fn.getcwd()
    if string.match(cwd, '^' .. src_dir .. '/ewc%-app%-.+$') then
        return {
            search_dirs = {
                cwd,
                src_dir .. '/surge-app-core',
                src_dir .. '/front-app-core',
                src_dir .. '/front-app-ewc'
            }
        }
    end
    return {}
end

local builtin = require('telescope.builtin')
FindFiles = function()
    builtin.find_files(get_opts())
end
LiveGrep = function()
    builtin.live_grep(get_opts())
end
vim.keymap.set('n', '<leader>ff', "<cmd>lua FindFiles()<CR>", { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', "<cmd>lua LiveGrep()<CR>", { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { desc = 'List buffers' })
vim.keymap.set('n', '<leader>fh', "<cmd>lua require('telescope.builtin').builtin.help_tags()<CR", { desc = 'Help tags' })

require('telescope').load_extension('fzf')

require('lualine').setup({
    options = { theme = 'catppuccin' },
})

-- nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local tree_on_attach = function(bufnr)
    local api = require "nvim-tree.api"
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<leader>th', api.tree.toggle_help, { desc = 'Toggle NvimTree help' })
end

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    on_attach = tree_on_attach
})

vim.keymap.set('n', "<leader>tt", "<cmd>NvimTreeToggle<cr>", { desc = 'Toggle NvimTree' })

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        'tsserver',
        'efm',
        'bashls',
        'cssls',
        'html',
        'gradle_ls',
        'groovyls',
        'lua_ls',
        'jsonls',
        'yamlls',
        'lemminx',
        'marksman',
        -- 'vimls'
    }
})

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
    require('lsp_mappings').setup(bufnr)
end

require('mason-lspconfig').setup_handlers({
    function(server_name)
        if server_name == 'jdtls' then
            -- do nothing
        elseif server_name == 'efm' then
            local bin_path = './node_modules/.bin'
            local config = { {
                lintCommand = bin_path .. "/eslint -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
                formatCommand = bin_path .. '/prettier --stdin-filepath ${INPUT}',
                formatStdin = true
            } }
            lspconfig.efm.setup {
                init_options = { documentFormatting = true },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                settings = {
                    rootMarkers = { ".git/" },
                    languages = {
                        typescript = config,
                        javascript = config,
                        typescriptreact = config,
                        javascriptreact = config,
                    }
                }
            }
            vim.cmd('command! -nargs=0 Lint :lua vim.lsp.buf.format()')
            vim.cmd([[
          augroup LintAutogroup
            autocmd!
            autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx Lint
          augroup END
        ]])
        elseif server_name == 'tsserver' then
            lspconfig.tsserver.setup {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    lsp_attach(client, bufnr)
                end,
                capabilities = lsp_capabilities
            }
        else
            lspconfig[server_name].setup({
                on_attach = lsp_attach,
                capabilities = lsp_capabilities
            })
        end
    end
})

local lspkind = require('lspkind')
local compare = require('cmp.config.compare')
local cmp = require('cmp')
cmp.setup {
    sources = {
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vsnip' },
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            require('cmp_tabnine.compare'),
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- because we are using the vsnip cmp plugin
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    formatting = {
        format = lspkind.cmp_format({
            -- mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                if entry.source.name == "cmp_tabnine" then
                    vim_item.kind = '🚀'
                    vim_item.menu = 'Tabnine'
                end
                return vim_item
            end
        })
    }
}

require('gitsigns').setup {
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

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

vim.keymap.set('n', '<leader>du', require 'dapui'.toggle, { desc = 'Toggle DAP UI' })

require 'jdtl_config'

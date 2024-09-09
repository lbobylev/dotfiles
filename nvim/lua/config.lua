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

require('spectre').setup({})
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    { desc = "Search current word" })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    { desc = "Search on current file" })

require('trouble').setup({})
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble<CR>', { noremap = true, silent = true })

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
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files(get_opts())
end, {})
vim.keymap.set('n', '<leader>fg', function()
    builtin.live_grep(get_opts())
end, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

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
    vim.keymap.set('n', '<leader>th', api.tree.toggle_help)
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

vim.keymap.set('n', "<leader>tt", "<cmd>NvimTreeToggle<cr>")

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

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
        map('n', '<leader>td', gitsigns.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}

vim.keymap.set('n', '<leader>du', require 'dapui'.toggle)

require 'jdtl_config'

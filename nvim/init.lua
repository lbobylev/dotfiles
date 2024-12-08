-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Set line numbers
vim.opt.number = true

-- Set tab and indentation options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Initialize plugin manager
vim.cmd('packadd packer.nvim')

require 'packer'.startup(function(use)
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-jdtls'
    use 'nvim-neotest/nvim-nio'
    use 'rcarriga/nvim-dap-ui'
    use 'rcarriga/nvim-notify' -- optional dependency for folke/noice.nvim
    use 'j-hui/fidget.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use "rebelot/kanagawa.nvim"
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'lewis6991/gitsigns.nvim'
    use { 'akinsho/bufferline.nvim', tag = '*' }
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'kevinhwang91/promise-async'
    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
    -- use {'tzachar/cmp-tabnine', run = './install.sh'}
    use 'zbirenbaum/copilot.lua'
    use 'zbirenbaum/copilot-cmp'
    -- use { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' }
    use 'folke/trouble.nvim'
    use 'folke/which-key.nvim'
    -- use {
    --     'VonHeikemen/fine-cmdline.nvim',
    --     requires = {
    --         { 'MunifTanjim/nui.nvim' }
    --     }
    -- }
    use 'nvim-pack/nvim-spectre'
    use 'goolord/alpha-nvim'
    use 'echasnovski/mini.diff'
    use 'echasnovski/mini.icons'
    use 'onsails/lspkind.nvim'
    use 'hedyhli/outline.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate', -- Automatically install parsers
    }
    use {
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require 'render-markdown'.setup {
                file_types = { 'markdown', 'codecompanion' },
            }
        end,
    }
    use {
        'olimorris/codecompanion.nvim',
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            -- "nvim-telescope/telescope.nvim",                                                       -- Optional: For using slash commands
            -- "stevearc/dressing.nvim"                                                               -- Optional: Improves `vim.ui.select`
        }
    }
end)

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "markdown", "markdown_inline", "latex", "yaml" }, -- List of parsers to install
    highlight = {
        enable = true,                                                     -- Enable highlighting
        -- additional_vim_regex_highlighting = false,  -- Disable additional regex highlighting
    },
    indent = {
        enable = true, -- Enable indentation
    },
}


-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set colorscheme
vim.cmd('colorscheme catppuccin-mocha')
-- vim.cmd('colorscheme kanagawa')
-- vim.cmd('set termguicolors')
-- vim.cmd('colorscheme desert')

require 'copilot_config'
-- require 'noice_config'
require 'cmp_config'
require 'telescope_config'
require 'lsp_config'
require 'gitsigns_config'
require 'nvim_tree_config'
require 'jdtls_config'
require 'spectre_config'

-- Настройка горячих клавиш для перемещения между буферами
-- Используем <A-...> для Option и <D-...> для Command
vim.api.nvim_set_keymap('n', '<leader>j', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
vim.api.nvim_set_keymap('n', '<leader>k', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })

require 'catppuccin'.setup {
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        --[[notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
        },]]
    }
}

require 'outline'.setup {}

local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
alpha.setup(dashboard.config)

require 'trouble'.setup {}
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble<CR>', { noremap = true, silent = true, desc = 'Trouble' })

vim.o.foldcolumn = '1' -- Указывает, сколько колонок отводить под индикаторы сворачивания
vim.o.foldlevel = 99   -- Уровень сворачивания (99 означает, что код изначально не свернут)
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require 'ufo'.setup {
    close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
        json = { 'array' }
    },
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
}
require 'nvim-autopairs'.setup {
    --disable_filetype = { 'TelescopePrompt' , 'vim' },
}
require 'Comment'.setup {}
require('bufferline').setup {}
require 'lualine'.setup {
    options = {
        theme = 'catppuccin'
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
            'encoding',
            'fileformat',
            'filetype',
            {
                -- Custom component to show the current Conda environment only for Python files
                function()
                    local env = os.getenv("CONDA_DEFAULT_ENV") -- Get the current Conda environment
                    return env and "🐍 " .. env or "" -- Return the environment name with a snake emoji
                end,
                color = { fg = '#ff9e64' }, -- Customize the color as needed
                cond = function()
                    return os.getenv("CONDA_DEFAULT_ENV") ~= nil and
                        vim.bo.filetype == 'python' -- Check if it's a Python file and an environment is set
                end
            }
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

vim.keymap.set('n', '<leader>du', function()
    require 'dapui'.toggle { reset = true }
end, { desc = 'Toggle dap ui' })

vim.keymap.set('n', '<leader>dU', function()
    require 'dapui'.toggle { reset = true, layout = 1 }
end, { desc = 'Toggle dap ui' })

-- vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })
-- Key bindings for resizing windows
vim.api.nvim_set_keymap('n', '<leader><Up>', ':resize +5<CR>',
    { noremap = true, silent = true, desc = 'Increase window height' })
vim.api.nvim_set_keymap('n', '<leader><Down>', ':resize -5<CR>',
    { noremap = true, silent = true, desc = 'Decrease window height' })
vim.api.nvim_set_keymap('n', '<leader><Left>', ':vertical resize -5<CR>',
    { noremap = true, silent = true, desc = 'Decrease window width' })
vim.api.nvim_set_keymap('n', '<leader><Right>', ':vertical resize +5<CR>',
    { noremap = true, silent = true, desc = 'Increase window width' })
vim.keymap.set('n', '<leader>u', function()
    local modules_to_reload = {
        "copilot_config",
        "jdtls_config",
        "telescope_config",
        "lsp_config",
    }
    for _, module in ipairs(modules_to_reload) do
        package.loaded[module] = nil
        return require(module)
    end
end, { noremap = true, silent = true, desc = 'Reload config' })

require 'fidget'.setup {
    progress = {
        display = {
            render_limit = 5
        }
    },
    notification = {
        window = {
            -- max_width = 60
        }
    }
}

local notify = require 'notify'
vim.notify = notify
notify.setup {
    max_width = 50,
    max_height = 60,
    render = 'wrapped-default'
}

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function get_password(entry)
    local file = io.open('/Users/leonid/.openai', "r")
    if file then
        local content = file:read("*a")
        file:close()
        return trim(content)
    else
        return nil
    end
end

local openai_key = get_password 'openai'

local adapters = require 'codecompanion.adapters'
require 'codecompanion'.setup {
    strategies = {
        chat = {
            adapter = 'openai',
        },
        inline = {
            adapter = 'openai',
        },
        agent = {
            adapter = 'openai',
        },
    },
    adapters = {
        ollama = function()
            return adapters.extend('ollama', {
                name = 'llama3', -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = {
                        default = 'llama3.1:latest',
                    },
                    num_ctx = {
                        default = 16384,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
        openai = function()
            return adapters.extend('openai', {
                env = {
                    api_key = openai_key
                },
                schema = {
                    model = {
                        default = 'gpt-4o-mini'
                    }
                }
            })
        end
    },
    display = {
        chat = {
            render_headers = false,
            window = {
                layout = 'horizontal',
                width = 1,
                height = 0.4,
            }
        },
        diff = {
            provider = 'mini_diff',
            layout = 'horizontal',
        }
    }
}

vim.api.nvim_set_keymap('n', "<leader>aa", "<cmd>CodeCompanionActions<cr>",
    { noremap = true, silent = true, desc = 'Code Companion - Actions' })
vim.api.nvim_set_keymap('v', "<leader>aa", "<cmd>CodeCompanionActions<cr>",
    { noremap = true, silent = true, desc = 'Code Companion - Actions' })
vim.api.nvim_set_keymap('n', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
    { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
vim.api.nvim_set_keymap('v', "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>",
    { noremap = true, silent = true, desc = 'Code Companion - Toggle chat' })
vim.api.nvim_set_keymap('v', "<leader>ad", "<cmd>CodeCompanionChat Add<cr>",
    { noremap = true, silent = true, desc = 'Code Companion - Chat add' })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

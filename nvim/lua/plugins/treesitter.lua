return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects"
        },
        opts = {
            ensure_installed = { "markdown", "markdown_inline", "latex", "yaml", "python", "java", "lua", "typescript" },
            highlight = {
                enable = true,
                -- additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                    },
                },
            },
        },
        config = function(_, opts)
            require "nvim-treesitter.configs".setup(opts)
        end,
    },
    {
        "kiyoon/treesitter-indent-object.nvim",
        keys = {
            {
                "ai",
                function() require 'treesitter_indent_object.textobj'.select_indent_outer() end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (outer)",
            },
            {
                "aI",
                function()
                    require 'treesitter_indent_object.textobj'.select_indent_outer(true, 'V')
                    require 'treesitter_indent_object.refiner'.include_surrounding_empty_lines()
                end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (outer, line-wise)",
            },
            {
                "ii",
                function() require 'treesitter_indent_object.textobj'.select_indent_inner() end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (inner, partial range)",
            },
            {
                "iI",
                function() require 'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
            },
        },
    },
    {
        -- https://github.com/kiyoon/indent-blankline-v2.nvim
        "kiyoon/indent-blankline-v2.nvim",
        event = "BufReadPost",
        init = function()
            vim.opt.list = true
            -- vim.opt.listchars:append "space:⋅"
            -- vim.opt.listchars:append "eol:↴"
        end,
        opts = {
            space_char_blankline = " ",
            show_current_context = true,
            -- show_current_context_start = true,
        }
    },
}

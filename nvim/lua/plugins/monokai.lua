return {
    'tanvirtin/monokai.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require 'monokai'.setup {
            palette = {
                background = "#000000", -- "#3b3c35",
                foreground = "#fdfff1",
                cursor = "#fdfff1",
                cursor_text_color = "#000000",
                selection_foreground = "#3b3c35",
                selection_background = "#fdfff1",
                color0 = "#000000", -- "#3b3c35",
                color8 = "#000000", -- "#6e7066",
                color1 = "#f82570",
                color9 = "#f82570",
                color2 = "#a6e12d",
                color10 = "#a6e12d",
                color3 = "#e4db73",
                color11 = "#e4db73",
                color4 = "#fc961f",
                color12 = "#fc961f",
                color5 = "#ae81ff",
                color13 = "#ae81ff",
                color6 = "#66d9ee",
                color14 = "#66d9ee",
                color7 = "#fdfff1",
                color15 = "#fdfff1",
            }
        }

        vim.cmd("colorscheme monokai")
        -- vim.cmd("colorscheme monokai_pro")
        -- vim.cmd("colorscheme monokai_soda")
        -- vim.cmd("colorscheme monokai_ristretto")

        -- genral
        vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#000000" })

        -- lualine
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000" })

        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#000000" })

        vim.api.nvim_set_hl(0, "Search",
            { bg = "#715c2f", fg = "#ffffff", bold = false, italic = false, underline = false })
        vim.api.nvim_set_hl(0, "IncSearch",
            { bg = "#8a6f35", fg = "#ffffff", bold = false, italic = false, underline = false })

        -- vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { bg = "#121212", nocombine = true })
        -- vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { bg = "#1A1A1A", nocombine = true })
    end,
}

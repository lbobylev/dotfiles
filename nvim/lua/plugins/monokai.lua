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
        vim.cmd([[
                highlight Normal guibg=#000000
                highlight NormalFloat guibg=#000000
                highlight SignColumn guibg=#000000
                highlight LineNr guibg=#000000
                highlight CursorLine guibg=#000000
            ]])

        -- lualine
        vim.cmd([[
                highlight StatusLine   guibg=#000000
                highlight StatusLineNC   guibg=#000000
            ]])

        vim.cmd([[
                highlight TelescopeNormal        guibg=#000000
                highlight TelescopeBorder        guibg=#000000
                highlight TelescopePromptNormal  guibg=#000000
                highlight TelescopePromptBorder  guibg=#000000
                highlight TelescopeResultsNormal guibg=#000000
                highlight TelescopeResultsBorder guibg=#000000
                highlight TelescopePreviewNormal guibg=#000000
                highlight TelescopePreviewBorder guibg=#000000
                highlight TelescopeSelection     guibg=#000000
            ]])

        vim.cmd([[
                highlight Search guibg=#715c2f guifg=#ffffff gui=NONE
                highlight IncSearch guibg=#8a6f35 guifg=#ffffff gui=NONE
            ]])
    end,
}

return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    opts = {
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = {
                'encoding',
                'fileformat',
                'filetype',
                {
                    function()
                        local venv = os.getenv("VIRTUAL_ENV")
                        local conda = os.getenv("CONDA_DEFAULT_ENV")

                        if venv and venv ~= "" then
                            return "🐍 venv:" .. vim.fn.fnamemodify(venv, ":t")
                        elseif conda and conda ~= "" then
                            return "🐍 conda:" .. conda
                        end
                        return ""
                    end,
                    cond = function()
                        return vim.bo.filetype == "python"
                    end
                }
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        winbar = {},
        inactive_winbar = {},
        options = {
            disabled_filetypes = {
                statusline = {
                    "NvimTree",
                    "lazy",
                    "alpha",
                    "spectre_panel",
                    "spectre_replace",
                    "spectre_preview",
                    "TelescopePrompt",
                    -- "dashboard",
                    -- "starter",
                    -- "Outline",
                }
            }
        }
    }
}

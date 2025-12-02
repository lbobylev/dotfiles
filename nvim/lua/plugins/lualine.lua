return {
    'nvim-lualine/lualine.nvim',
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
                        local env = os.getenv("CONDA_DEFAULT_ENV")
                        return env and "🐍 " .. env or ""
                    end,
                    cond = function()
                        return os.getenv("CONDA_DEFAULT_ENV") ~= nil and
                            vim.bo.filetype == 'python'
                    end
                }
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
    }

}

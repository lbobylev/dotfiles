local map = vim.keymap.set

return {
    {
        "mfussenegger/nvim-dap",
        -- event = "VeryLazy",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", 'nvim-neotest/nvim-nio' },
        config = function()
            local jdtls = require 'jdtls'
            local dap = require 'dap'
            local dapui = require 'dapui'

            dapui.setup {
                layouts = {
                    {
                        elements = {
                            -- { id = "repl",        size = 0.30 },
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        position = "right",
                        size = 5
                    },
                    {
                        elements = {
                            { id = "repl", size = 1 }
                        },
                        position = "bottom",
                        size = 20
                    },
                    {
                        elements = {
                            { id = "console", size = 1 }
                        },
                        position = "bottom",
                        size = 25
                    },
                },
            }

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                -- dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                -- dapui.close()
            end

            -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
            -- you make during a debug session immediately.
            -- Remove the option if you do not want that.
            jdtls.setup_dap { hotcodereplace = 'auto' }
            require 'dap.ext.vscode'.load_launchjs()

            map('n', '<leader>du', function() dapui.toggle { reset = true } end, { desc = 'Toggle dap ui' })
            map('n', '<leader>dU', function() dapui.toggle { reset = true, layout = 1 } end, { desc = 'Toggle dap ui' })
        end
    },

}

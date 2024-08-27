local home = os.getenv('HOME')
local jdtls = require('jdtls')
local os = require('os')

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local project_folder = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_folder = home .. "/.local/share/eclipse/" .. project_folder

-- Helper function for creating keymaps
function nnoremap(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
    require("lsp_mappings").setup(bufnr)

    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Java extensions provided by jdtls
    nnoremap("<C-o>", jdtls.organize_imports, opts, "Organize imports")
    nnoremap("<space>ev", jdtls.extract_variable, opts, "Extract variable")
    nnoremap("<space>ec", jdtls.extract_constant, opts, "Extract constant")
    vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

    -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
    -- you make during a debug session immediately.
    -- Remove the option if you do not want that.
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('dap.ext.vscode').load_launchjs()

    -- nvim-dap
    nnoremap("<space>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts, "Set breakpoint")
    nnoremap("<space>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts,
        "Set conditional breakpoint")
    nnoremap("<space>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts,
        "Set log point")
    nnoremap('<space>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", opts, "Clear breakpoints")
    nnoremap('<space>ba', '<cmd>Telescope dap list_breakpoints<cr>', opts, "List breakpoints")

    nnoremap("<F5>", "<cmd>lua require'dap'.continue()<cr>", opts, "Continue")
    nnoremap("<F8>", "<cmd>lua require'dap'.step_over()<cr>", opts, "Step over")
    nnoremap("<F7>", "<cmd>lua require'dap'.step_into()<cr>", opts, "Step into")
    nnoremap("<space>do", "<cmd>lua require'dap'.step_out()<cr>", opts, "Step out")
    nnoremap('<space>dd', "<cmd>lua require'dap'.disconnect()<cr>", opts, "Disconnect")
    nnoremap('<space>dt', "<cmd>lua require'dap'.terminate()<cr>", opts, "Terminate")
    nnoremap("<space>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts, "Open REPL")
    nnoremap("<space>dl", "<cmd>lua require'dap'.run_last()<cr>", opts, "Run last")
    nnoremap('<space>di', function() require "dap.ui.widgets".hover() end, opts, "Variables")
    nnoremap('<space>ds', function()
        local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
    end, opts, "Scopes")
    nnoremap('<space>df', '<cmd>Telescope dap frames<cr>', opts, "List frames")
    nnoremap('<space>dh', '<cmd>Telescope dap commands<cr>', opts, "List commands")
    --nnoremap('<space>du', "<cmd>lua require'dapui'.toggle()<cr>", opts)

    nnoremap("<space>tc", jdtls.test_class, opts, "Test class (DAP)")
    nnoremap("<space>m", jdtls.test_nearest_method, opts, "Test method (DAP)")

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
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
        dapui.close()
    end
end

local jdtls_dir = home .. '/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
local tools_dir = home .. '/.local/share/nvim/mason/share'
local bundles = {
    vim.fn.glob(tools_dir .. '/java-debug-adapter/com.microsoft.java.debug.plugin-0.53.0.jar'),
    vim.fn.glob(tools_dir .. '/java-test/com.microsoft.java.test.plugin-0.41.1.jar'),
    -- vim.fn.glob(tools_dir .. '/java-test/jacocoagent.jar'),
    -- vim.fn.glob(tools_dir .. '/java-test/com.microsoft.java.test.runner-jar-with-dependencies.jar'),
    vim.fn.glob(tools_dir .. '/java-test/junit-jupiter-api_5.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-test/junit-jupiter-engine_5.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-test/junit-jupiter-migrationsupport_5.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-test/junit-jupiter-params_5.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-commons_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-engine_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-launcher_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-runner_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-suite-api_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-suite-commons_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-platform-suite-engine_1.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/junit-vintage-engine_5.9.3.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/org.apiguardian.api_1.1.2.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/org.eclipse.jdt.junit4.runtime_1.3.0.v20220609-1843.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/org.eclipse.jdt.junit5.runtime_1.1.100.v20220907-0450.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/org.opentest4j_1.2.0.jar'),
    vim.fn.glob(tools_dir .. '/java-lest/org.jacoco.core_0.8.12.202403310830.jar'),
}
-- vim.list_extend(bundles, vim.split(vim.fn.glob(tools_dir .. '/java-test/*.jar', 1), "\n"))

local config = {
    flags = {
        debounce_text_changes = 80,
    },
    init_options = {
        bundles = bundles
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
    root_dir = root_dir,   -- Set the root directory to our found root_marker
    -- Here you can configure eclipse.jdt.ls specific settings
    -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            format = {
                settings = {
                    -- Use Google Java style guidelines for formatting
                    -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                    -- and place it in the ~/.local/share/eclipse directory
                    url = home .. "/.local/share/eclipse/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
            -- Specify any completion options
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*", "sun.*",
                },
            },
            -- Specify any options for organizing imports
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            -- How code generation should act
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            -- If you are developing in projects with different Java versions, you need
            -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- And search for `interface RuntimeOption`
            -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = home .. "/.sdkman/candidates/java/21.0.4-amzn",
                    },
                    {
                        name = "JavaSE-17",
                        path = home .. "/.sdkman/candidates/java/17.0.11-amzn",
                    },
                    {
                        name = "JavaSE-11",
                        path = home .. "/.sdkman/candidates/java/11.0.23-amzn"
                    },
                }
            }
        }
    },
    -- cmd is the command that starts the language server. Whatever is placed
    -- here is what is passed to the command line to execute jdtls.
    -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    -- for the full list of options
    cmd = {
        home .. "/.sdkman/candidates/java/17.0.11-amzn/bin/java",
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
        -- '-javaagent:' .. home .. '/.local/share/eclipse/lombok.jar',

        -- The jar file is located where jdtls was installed. This will need to be updated
        -- to the location where you installed jdtls
        -- '-jar', vim.fn.glob(tools_dir .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-jar', vim.fn.glob(jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

        -- The configuration for jdtls is also placed where jdtls was installed. This will
        -- need to be updated depending on your environment
        -- '-configuration', tools_dir .. '/jdtls/config',
        '-configuration', jdtls_dir .. '/config_mac',

        -- Use the workspace_folder defined above to store data for this project
        '-data', workspace_folder,
    },
}


-- local filename = home .. '/src/' .. project_folder .. '/.classpath'
-- local success, err = os.remove(filename)
--[[if success then
    vim.notify('File "' .. filename .. '" deleted successfully.', vim.log.levels.INFO)
else
    vim.notify('Failed to delete file "' .. filename .. '": ' .. err, vim.log.levels.ERROR)
end]]

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(config)

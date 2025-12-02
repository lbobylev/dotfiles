local home = os.getenv('HOME')
local jdtls = require 'jdtls'
local dap = require 'dap'
local widgets = require 'dap.ui.widgets'

local function map(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end

local root_markers = { 'settings.gradle', 'build.gradle', 'gradlew', 'mvnw', '.git' }
local root_dir = require 'jdtls.setup'.find_root(root_markers)
local project_folder = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_folder = home .. "/.local/share/eclipse/" .. project_folder
if vim.fn.isdirectory(workspace_folder) == 1 then
    vim.fn.delete(workspace_folder, 'rf')
end

local on_attach = function(client, bufnr)
    require 'lsp_mappings'.setup(bufnr)

    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- map("<C-o>", jdtls.organize_imports, opts, "Organize imports")
    map("<leader>ev", jdtls.extract_variable, opts, "Extract variable")
    map("<leader>ec", jdtls.extract_constant, opts, "Extract constant")
    vim.keymap.set('v', "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

    -- nvim-dap
    map("<leader>bb", dap.toggle_breakpoint, opts, "Set breakpoint")
    map("<leader>bc", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts,
        "Set conditional breakpoint")
    map("<leader>bl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, opts, "Set log point")
    map('<leader>br', dap.clear_breakpoints, opts, "Clear breakpoints")
    map("<leader>dc", dap.continue, opts, "Continue")
    map("<leader>dn", dap.step_over, opts, "Step over")
    map("<leader>di", dap.step_into, opts, "Step into")
    map("<leader>do", dap.step_out, opts, "Step out")
    map('<leader>dd', dap.disconnect, opts, "Disconnect")
    map('<leader>dt', dap.terminate, opts, "Terminate")
    map("<leader>dr", dap.repl.toggle, opts, "Open repl")
    map("<leader>dl", dap.run_last, opts, "Run last")
    map('<leader>dv', widgets.hover, opts, "Variables")
    map('<leader>ds', function() widgets.centered_float(widgets.scopes) end, opts, "Scopes")

    -- map('<leader>df', '<cmd>Telescope dap frames<cr>', opts, "List frames")
    -- map('<leader>dh', '<cmd>Telescope dap commands<cr>', opts, "List commands")
    -- map('<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', opts, "List breakpoints")
    -- map("<leader>z", wipe_data_and_restart, opts, "Wipe data and restart")

    local java_test_config = {
        vmArgs = "--add-opens=java.base/java.io=ALL-UNNAMED"
    }
    map("<leader>tc", function()
        jdtls.test_class({ config_overrides = java_test_config })
    end, opts, "Test class")
    map("<leader>tm", function()
        jdtls.test_nearest_method({ config_overrides = java_test_config })
    end, opts, "Test method")
end

local jdtls_dir = home .. '/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
local bundles = {
    vim.fn.glob(home .. '/src/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'),
}
local test_bundles = {
}
vim.list_extend(bundles, test_bundles)

jdtls.start_or_attach {
    flags = {
        debounce_text_changes = 80,
    },
    init_options = {
        bundles = bundles
    },
    capabilities = require 'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    root_dir = root_dir,
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            format = {
                settings = {
                    -- Use Google Java style guidelines for formatting
                    -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                    -- and place it in the ~/.local/share/eclipse directory
                    url = home .. "/.config/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
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
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
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

        '-Xms8g',                      -- Set initial heap size to 8 GB
        '-Xmx12g',                     -- Set maximum heap size to 12 GB
        '-XX:+UseG1GC',                -- Use G1 Garbage Collector
        '-XX:+UseStringDeduplication', -- Reduce memory footprint by deduplicating strings
        '-XX:MaxGCPauseMillis=200',    -- Target maximum GC pause time
        '-XX:+AlwaysPreTouch',


        -- '-XX:+UnlockExperimentalVMOptions', -- Unlock experimental VM options
        -- '-XX:+AggressiveOpts',              -- Enable aggressive optimizations
        '-XX:+OptimizeStringConcat', -- Optimize string concatenation
        '-XX:+UseCompressedOops',    -- Use compressed references for 64-bit JVMs


        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '--add-opens', 'java.base/java.io=ALL-UNNAMED',
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

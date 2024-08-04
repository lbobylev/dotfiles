local home = os.getenv('HOME')
local jdtls = require 'jdtls'

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require 'jdtls.setup'.find_root(root_markers)

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

local lsp = vim.lsp
---@diagnostic disable-next-line: deprecated
local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients

---@return string?, vim.lsp.Client?
local function extract_data_dir(bufnr)
    -- Prefer client from current buffer, in case there are multiple jdtls clients (multiple projects)
    local client = get_clients({ name = "jdtls", bufnr = bufnr })[1]
    if not client then
        -- Try first matching jdtls client otherwise. In case the user is in a
        -- different buffer like the quickfix list
        local clients = get_clients({ name = "jdtls" })
        if vim.tbl_count(clients) > 1 then
            ---@diagnostic disable-next-line: cast-local-type
            client = require 'jdtls.ui'.pick_one(
                clients,
                'Multiple jdtls clients found, pick one: ',
                function(c) return c.config.root_dir end
            )
        else
            client = clients[1]
        end
    end

    if client and client.config and client.config.cmd then
        local cmd = client.config.cmd
        if type(cmd) == "table" then
            for i, part in pairs(cmd) do
                -- jdtls helper script uses `--data`, java jar command uses `-data`.
                if part == '-data' or part == '--data' then
                    return client.config.cmd[i + 1], client
                end
            end
        end
    end

    return nil, nil
end

local function wipe_data_and_restart()
    local data_dir, client = extract_data_dir(vim.api.nvim_get_current_buf())
    if not data_dir or not client then
        vim.notify(
            "Data directory wasn't detected. " ..
            "You must call `start_or_attach` at least once and the cmd must include a `-data` parameter (or `--data` if using the official `jdtls` wrapper)")
        return
    end
    vim.schedule(function()
        local bufs = vim.lsp.get_buffers_by_client_id(client.id)
        client.stop()
        vim.wait(30000, function()
            return vim.lsp.get_client_by_id(client.id) == nil
        end)
        vim.fn.delete(data_dir, 'rf')
        local client_id
        if vim.bo.filetype == "java" then
            client_id = lsp.start(client.config)
        else
            client_id = vim.lsp.start_client(client.config)
        end
        if client_id then
            for _, buf in ipairs(bufs) do
                lsp.buf_attach_client(buf, client_id)
            end
        end
    end)
end

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
    require 'lsp_mappings'.setup(bufnr)
    local dap = require 'dap'
    local dapui = require 'dapui'
    local widgets = require 'dap.ui.widgets'

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

    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- Java extensions provided by jdtls
    -- nnoremap("<C-o>", jdtls.organize_imports, opts, "Organize imports")
    nnoremap("<leader>ev", jdtls.extract_variable, opts, "Extract variable")
    nnoremap("<leader>ec", jdtls.extract_constant, opts, "Extract constant")
    vim.keymap.set('v', "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

    -- nvim-dap
    nnoremap("<leader>bb", dap.toggle_breakpoint, opts, "Set breakpoint")
    nnoremap("<leader>bc", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts,
        "Set conditional breakpoint")
    nnoremap("<leader>bl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, opts, "Set log point")
    nnoremap('<leader>br', dap.clear_breakpoints, opts, "Clear breakpoints")
    nnoremap("<leader>dc", dap.continue, opts, "Continue")
    nnoremap("<leader>dn", dap.step_over, opts, "Step over")
    nnoremap("<leader>di", dap.step_into, opts, "Step into")
    nnoremap("<leader>do", dap.step_out, opts, "Step out")
    nnoremap('<leader>dd', dap.disconnect, opts, "Disconnect")
    nnoremap('<leader>dt', dap.terminate, opts, "Terminate")
    nnoremap("<leader>dr", dap.repl.toggle, opts, "Open repl")
    nnoremap("<leader>dl", dap.run_last, opts, "Run last")
    nnoremap('<leader>dv', widgets.hover, opts, "Variables")
    nnoremap('<leader>ds', function() widgets.centered_float(widgets.scopes) end, opts, "Scopes")

    -- nnoremap('<leader>df', '<cmd>Telescope dap frames<cr>', opts, "List frames")
    -- nnoremap('<leader>dh', '<cmd>Telescope dap commands<cr>', opts, "List commands")
    -- nnoremap('<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', opts, "List breakpoints")

    nnoremap("<leader>tc", jdtls.test_class, opts, "Test class")
    nnoremap("<leader>tm", jdtls.test_nearest_method, opts, "Test method")
    nnoremap("<leader>z", wipe_data_and_restart, opts, "Wipe data and restart")
end

local jdtls_dir = home .. '/src/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
-- local jdtls_dir = home .. '/Downloads/jdt-language-server-1.30.0-202311301503'
local bundles = {
    vim.fn.glob(home .. '/src/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'),
}
local test_bundles = {
    -- "/Users/leonid/src/vscode-java-test/server/com.microsoft.java.test.plugin-0.42.0.jar",
    -- "/Users/leonid/src/vscode-java-test/server/com.microsoft.java.test.runner-jar-with-dependencies.jar"
} -- vim.split(vim.fn.glob(home .. '/src/vscode-java-test/server/*.jar', 1), "\n")
-- local inspect = require 'inspect'
-- vim.notify(inspect(test_bundles))
vim.list_extend(bundles, test_bundles)

local config = {
    flags = {
        debounce_text_changes = 80,
    },
    init_options = {
        bundles = bundles
    },
    capabilities = require 'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
                    url = home .. "/.config/eclipse-java-google-style.xml",
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

-- Создаем автокоманду для файлов Java
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        -- Finally, start jdtls. This will run the language server using the configuration we specified,
        -- setup the keymappings, and attach the LSP client to the current buffer
        jdtls.start_or_attach(config)
    end,
})

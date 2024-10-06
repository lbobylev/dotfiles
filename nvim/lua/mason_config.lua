require 'mason'.setup()
require 'mason-lspconfig'.setup {
    ensure_installed = {
        'ts_ls',
        'efm',
        'bashls',
        'cssls',
        'html',
        'gradle_ls',
        'groovyls',
        'lua_ls',
        'jsonls',
        'yamlls',
        'lemminx',
        'marksman',
        'vimls'
    }
}

local lspconfig = require 'lspconfig'
local lsp_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
local lsp_attach = function(client, bufnr)
    require 'lsp_mappings'.setup(bufnr)
end

require 'mason-lspconfig'.setup_handlers {
    function(server_name)
        if server_name == 'jdtls' then
            -- do nothing
        elseif server_name == 'efm' then
            local bin_path = './node_modules/.bin'
            local config = {
                lintCommand = bin_path .. '/eslint -f unix --stdin --stdin-filename ${INPUT}',
                lintStdin = true,
                lintFormats = { '%f:%l:%c: %m' },
                formatCommand = bin_path .. '/prettier --stdin-filepath ${INPUT}',
                formatStdin = true
            }
            lspconfig.efm.setup {
                init_options = { documentFormatting = true },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                settings = {
                    rootMarkers = { '.git/' },
                    languages = {
                        typescript = config,
                        javascript = config,
                        typescriptreact = config,
                        javascriptreact = config,
                    }
                }
            }
            vim.cmd 'command! -nargs=0 Lint :lua vim.lsp.buf.format()'
            vim.cmd [[
              augroup LintAutogroup
                autocmd!
                autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx Lint
              augroup END
            ]]
        elseif server_name == 'ts_ls' then
            lspconfig.ts_ls.setup {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    lsp_attach(client, bufnr)
                end,
                capabilities = lsp_capabilities
            }
        else
            lspconfig[server_name].setup {
                on_attach = lsp_attach,
                capabilities = lsp_capabilities
            }
        end
    end
}

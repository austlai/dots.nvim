return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "html",
                    "cssls",
                    "lua_ls",
                    "basedpyright",
                    "phpactor@2023.09.24.0",
                    "eslint",
                    "marksman",
                    "intelephense",
                    "thriftls",
                    -- "angularls",
                },
            })

            -- Can install tools... eslint_d? pylint? black?
            require("mason-tool-installer").setup({
                ensure_installed = {},
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
            "williamboman/mason.nvim",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { noremap = true, buffer = ev.buf, silent = true }
                    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(
                    vim.lsp.handlers.hover, {
                        border = "single",
                    }
                    )
                    vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(
                    vim.lsp.handlers.signature_help, {border = "single"}
                    )
                end,
            })

            local lspconfig = require("lspconfig")
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            require("mason-lspconfig").setup_handlers({
                function(server)
                    lspconfig[server].setup({
                        capabilities = capabilities,
                    })
                end,
                -- ["angularls"] = function()
                --   -- Setup taken from https://github.com/gmr458/nvim/blob/321f118faf5ed0c84550e52a9978523e794ef688/lua/gmr/configs/lsp/settings/angularls.lua
                --   local angularls_path = require("mason-registry").get_package('angular-language-server'):get_install_path()
                --   local cmd = {
                --     'ngserver',
                --     '--stdio',
                --     '--tsProbeLocations',
                --     table.concat({
                --       angularls_path,
                --       vim.uv.cwd(),
                --     }, ','),
                --     '--ngProbeLocations',
                --     table.concat({
                --       angularls_path .. '/node_modules/@angular/language-server',
                --       vim.uv.cwd(),
                --     }, ','),
                --   }

                --   lspconfig.angularls.setup({
                --     capabilities = capabilities,
                --     cmd = cmd,
                --     on_attach = function(client)
                --       client.server_capabilities.diagnosticProvider = false
                --       client.server_capabilities.hoverProvider = false
                --     end,
                --   })
                -- end,
                ["basedpyright"] = function()
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                    })
                end,
                ["eslint"] = function()
                    lspconfig.eslint.setup({
                        capabilities = capabilities,
                        -- NOTE: FREELANCER ROOT_DIR
                        root_dir = function(fname)
                          -- Check if 'api-e2e' exists in the path
                          if string.match(fname, "api%-e2e") then
                            return '/home/alai/freelancer-dev/fl-gaf/api-e2e'
                          else
                            -- Fallback to the webapp directory
                            return '/home/alai/freelancer-dev/fl-gaf/webapp'
                          end
                        end,
                    })
                end,
                ['phpactor'] = function()
                    lspconfig.phpactor.setup({
                        capabilities = capabilities,
                        on_attach = function(client)
                          client.server_capabilities.hoverProvider = false
                          client.server_capabilities.documentSymbolProvider = false
                          client.server_capabilities.referencesProvider = false
                          client.server_capabilities.completionProvider = false
                          client.server_capabilities.documentFormattingProvider = false
                          client.server_capabilities.definitionProvider = false
                          client.server_capabilities.implementationProvider = true
                          client.server_capabilities.typeDefinitionProvider = false
                          client.server_capabilities.diagnosticProvider = false
                        end,
                        init_options = {
                            ["logging.enabled"] = false,
                            ["logging.level"] = 'debug',
                            ["logging.path"] = 'phpactor.log',
                            ["language_server_phpstan.enabled"] = false,
                            ["language_server_psalm.enabled"] = true,
                            ["language_server_psalm.threads"] = 16,
                            ["language_server_psalm.timeout"] = 60,
                            ["php_code_sniffer.enabled"] = false,
                            -- ["php_code_sniffer.args"] = {'--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml'},
                            ["prophecy.enabled"] = false,
                            ["language_server.diagnostic_outsource"] = false,
                            ["language_server.diagnostics_on_update"] = false,
                        }
                    })
                end,
                ['intelephense'] = function()
                    lspconfig.intelephense.setup({
                        capabilities = capabilities,
                        on_attach = function(client)
                          client.server_capabilities.workspaceSymbolProvider = false
                        end,
                        settings = {
                          php = {
                            completion = {
                              callSnippet = "Replace"
                            }
                          }
                        },
                    })
                end
            })
        end
    }
}

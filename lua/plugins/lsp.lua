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
                    "eslint",
                    "marksman",
                    "intelephense",
                    "thriftls",
                    "psalm@5.26.1"
                    -- "phpactor@2023.09.24.0",
                    -- "angularls@17.3.2",
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
            {
              "SmiteshP/nvim-navbuddy",
              dependencies = {
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim"
              },
              opts = {},
              config = function()
                vim.keymap.set("n", "<Leader>n", ":Navbuddy<CR>", { silent = true, desc = "Open Navbuddy" })
              end
            }
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { noremap = true, buffer = ev.buf, silent = true }
                    vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = 1, float = true}) end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = -1, float = true}) end, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                end,
            })

            local lspconfig = require("lspconfig")
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local navbuddy = require("nvim-navbuddy")

            require("mason-lspconfig").setup_handlers({
                -- ["angularls"] = function()
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
                --     '--experimental-ivy'
                --   }

                --   lspconfig.angularls.setup({
                --     capabilities = capabilities,
                --     cmd = cmd,
                --   })
                -- end,
                -- ["vtsls"] = function()
                --   lspconfig.vtsls.setup({
                --     capabilities = capabilities,
                --     on_attach = function(client, bufnr)
                --       navbuddy.attach(client, bufnr)
                --     end,
                --     settings = {
                --       typescript = {
                --         preferences = {
                --           importModuleSpecifier = "non-relative",
                --         },
                --       },
                --     }
                --   })
                -- end,
                ["basedpyright"] = function()
                  lspconfig.basedpyright.setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      navbuddy.attach(client, bufnr)
                    end,
                  })
                end,
                ["eslint"] = function()
                    lspconfig.eslint.setup({
                        capabilities = capabilities,
                        root_dir = function(fname)
                          -- Check if 'api-e2e' exists in the path
                          if string.match(fname, "api%-e2e") then
                            return '/home/alai/freelancer-dev/fl-gaf/api-e2e'
                          else
                            -- Fallback to the webapp directory
                            return '/home/alai/freelancer-dev/fl-gaf/webapp'
                          end
                        end,
                        flags = {
                          allow_incremental_sync = false,
                          debounce_text_changes = 1000
                        }
                    })
                end,
                -- NOTE: Stopped using phpactor until we upgrade to php8.1
                -- ['phpactor'] = function()
                --     lspconfig.phpactor.setup({
                --         capabilities = capabilities,
                --         on_attach = function(client)
                --           client.server_capabilities.hoverProvider = false
                --           client.server_capabilities.documentSymbolProvider = false
                --           client.server_capabilities.referencesProvider = false
                --           client.server_capabilities.completionProvider = false
                --           client.server_capabilities.documentFormattingProvider = false
                --           client.server_capabilities.definitionProvider = false
                --           client.server_capabilities.implementationProvider = true
                --           client.server_capabilities.typeDefinitionProvider = false
                --           client.server_capabilities.diagnosticProvider = false
                --         end,
                --         init_options = {
                --             ["logging.enabled"] = false,
                --             ["logging.level"] = 'debug',
                --             ["logging.path"] = 'phpactor.log',
                --             ["language_server_phpstan.enabled"] = false,
                --             ["language_server_psalm.enabled"] = true,
                --             ["language_server_psalm.threads"] = 16,
                --             ["language_server_psalm.timeout"] = 60,
                --             ["php_code_sniffer.enabled"] = false,
                --             ["prophecy.enabled"] = false,
                --             ["language_server.diagnostic_outsource"] = false,
                --             ["language_server.diagnostics_on_update"] = false,
                --             -- NOTE: This doesn't work with the current version of phpactor, we need to upgrade to php8.1
                --             -- ["php_code_sniffer.args"] = {'--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml'},
                --         }
                --     })
                -- end,
                -- ['intelephense'] = function()
                --     lspconfig.intelephense.setup({
                --         capabilities = capabilities,
                --         on_attach = function(client, bufnr)
                --           navbuddy.attach(client, bufnr)
                --           client.server_capabilities.workspaceSymbolProvider = false
                --         end,
                --         settings = {
                --           php = {
                --             completion = {
                --               callSnippet = "Replace"
                --             }
                --           }
                --         },
                --     })
                -- end
                --
                ['psalm'] = function ()
                  lspconfig.psalm.setup({
                    cmd = { "./vendor/bin/psalm", "--language-server" },
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      client.server_capabilities.completionProvider = false
                      client.server_capabilities.hoverProvider = false
                      client.server_capabilities.documentSymbolProvider = false
                    end,
                  })
                end,
                ['intelephense'] = function()
                    lspconfig.intelephense.setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                          navbuddy.attach(client, bufnr)
                        end,
                        settings = {
                          php = {
                            completion = {
                              callSnippet = "Replace"
                            }
                          }
                        },
                    })
                end,
                function(server)
                  lspconfig[server].setup({
                      capabilities = capabilities,
                  })
                end,
            })
        end
    },
    {

    }
}

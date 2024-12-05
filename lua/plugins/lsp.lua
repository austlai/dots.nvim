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
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup_handlers({
                function(server)
                    lspconfig[server].setup({
                        capabilities = capabilities,
                    })
                end,
                ["basedpyright"] = function()
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                    })
                end,
                ["eslint"] = function()
                    lspconfig.eslint.setup({
                        capabilities = capabilities,
                        -- NOTE: FREELANCER ROOT_DIR
                        root_dir = function()
                            return '/home/alai/freelancer-dev/fl-gaf/webapp'
                        end,
                    })
                end,
                ['phpactor'] = function()
                    lspconfig.phpactor.setup({
                        capabilities = capabilities,
                        init_options = {
                            ["logging.enabled"] = false,
                            ["logging.level"] = 'debug',
                            ["logging.path"] = 'phpactor.log',
                            ["language_server_phpstan.enabled"] = false,
                            ["language_server_psalm.enabled"] = true, --
                            ["language_server_psalm.threads"] = 16,
                            ["php_code_sniffer.enabled"] = false,
                            -- ["php_code_sniffer.args"] = {'--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml'},
                            ["prophecy.enabled"] = false,
                            ["language_server.diagnostic_outsource"] = false,
                            ["language_server.diagnostics_on_update"] = false,
                        }
                    })
                end
            })
        end
    }
}

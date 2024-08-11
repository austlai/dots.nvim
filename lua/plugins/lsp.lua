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
                    "tsserver",
                    "html",
                    "cssls",
                    "lua_ls",
                    "basedpyright",
                    "phpactor"
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

                    -- #borderssuck
                    -- vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(
                    --     vim.lsp.handlers.hover, {border = "rounded" }
                    -- )
                    -- vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(
                    --     vim.lsp.handlers.signature_help, {border = "rounded"}
                    -- )

                    vim.lsp.inlay_hint.enable(true)
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
                ['basedpyright'] = function ()
                    -- Disable diagnostics, potentially setup mypy?
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        handlers = {
                            ['textDocument/publishDiagnostics'] = function() end
                        }
                    })
                end,
            })
        end
    }
}

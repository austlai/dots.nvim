return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig").setup({
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
}

return {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
    config = function()
        require'nvim-treesitter.configs'.setup({
            ensure_installed = {
                "c",
                "cpp",
                "css",
                "html",
                "lua",
                "markdown",
                "php",
                "phpdoc",
                "python",
                "query",
                "scss",
                "typescript",
                "vim",
                "vimdoc",
            },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        })
    end
}

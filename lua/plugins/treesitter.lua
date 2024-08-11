-- Treesitter --

return {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
    config = function()
        require'nvim-treesitter.configs'.setup({
            ensure_installed = { "c", "cpp", "vim", "lua", "vimdoc", "query", "python", "php", "phpdoc", "typescript", "html", "css", "scss" },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        })
    end
}

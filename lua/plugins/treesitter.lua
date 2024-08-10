-- Treesitter --

return {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
    config = function()
        require'nvim-treesitter.configs'.setup {
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        }
    end
}

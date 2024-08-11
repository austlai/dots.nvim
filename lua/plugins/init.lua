-- Plugins --

return {
    "nvim-lua/plenary.nvim",
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").load("wave")
        end
    },
    'christoomey/vim-tmux-navigator',
    {
        'folke/todo-comments.nvim',
        event = "VimEnter",
        config = function()
            require('todo-comments').setup()
        end
    },

    -- TODO: replacements?
    'HiPhish/nvim-ts-rainbow2',
    'kyazdani42/nvim-web-devicons',
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },

    ---- LSP
}


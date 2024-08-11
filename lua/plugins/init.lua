-- Plugins --

return {
    -- Themes & Colours
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").load("wave")
        end
    },
    'HiPhish/nvim-ts-rainbow2',
    'kyazdani42/nvim-web-devicons',

    ---- QOL
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },
    {
        'folke/todo-comments.nvim',
        event = "VimEnter",
        config = function()
            require('todo-comments').setup()
        end
    },
    'christoomey/vim-tmux-navigator',

    ---- LSP
    'hrsh7th/cmp-cmdline',
    'onsails/lspkind-nvim',
    'L3MON4D3/LuaSnip',
}


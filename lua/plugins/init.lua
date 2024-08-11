return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        config = function()
            require("kanagawa").load("wave")
        end
    },
    "nvim-lua/plenary.nvim",
    'christoomey/vim-tmux-navigator',
    'HiPhish/rainbow-delimiters.nvim',
    {
        'folke/todo-comments.nvim',
        opts = {}
    },
}

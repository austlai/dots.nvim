return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").load("wave")
            -- Make floating window background match normal background
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
        end
    },
    "nvim-lua/plenary.nvim",
    "christoomey/vim-tmux-navigator",
    "HiPhish/rainbow-delimiters.nvim",
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        opts = {
            keywords = {
              WARN = { alt = { "ALAI" } },
            }
        },
    },
    {
      'echasnovski/mini.ai',
      version = false,
      config = function()
        require('mini.ai').setup()
      end
    },
}

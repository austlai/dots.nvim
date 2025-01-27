return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- require("kanagawa").load("wave")
            -- Make floating window background match normal background
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
        end
    },
    {
      "rose-pine/neovim",
      lazy = false,
      priority = 1000,
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          dim_inactive_windows = true,
          -- styles = {
          --   italic = false
          -- },
          highlight_groups = {
            CurSearch = { fg = "base", bg = "leaf", inherit = false },
            Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
          },
        })
        vim.cmd("colorscheme rose-pine")
      end
    },
    { "projekt0n/github-nvim-theme", name = "github-theme" },
    { "savq/melange-nvim" },
    { "ramojus/mellifluous.nvim" },
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
    {
      'echasnovski/mini.splitjoin',
      version = false,
      opts = {}
    },
}

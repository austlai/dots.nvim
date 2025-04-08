return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- require("kanagawa").load("wave")
            -- Make floating window background match normal background
            -- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            -- vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
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
        -- vim.cmd.colorscheme("rose-pine")
      end
    },
    {
      "wtfox/jellybeans.nvim",
      priority = 1000,
      config = function()
        require("jellybeans").setup()
        -- vim.cmd.colorscheme("jellybeans")

        -- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        -- vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
        -- vim.api.nvim_set_hl(0, "Pmenu", { link = "Normal" })
      end,
    },
    {
      "projekt0n/github-nvim-theme",
      name = "github-theme",
      config = function()
        -- vim.cmd.colorscheme("github_light_high_contrast")
      end,
    },
    { "ramojus/mellifluous.nvim" },
    {
      'sainnhe/edge',
      lazy = false,
      priority = 1000,
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.edge_enable_italic = true
        -- vim.cmd.colorscheme('edge')
      end
    },
    {
      "miikanissi/modus-themes.nvim",
      priority = 1000,
      config = function()
        -- vim.cmd.colorscheme("modus")
      end
    },
    {
      "EdenEast/nightfox.nvim",
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("terafox")

        vim.opt.guicursor = "n-c-v:block,i:-ver10,a:Cursor/lCursor"

        vim.api.nvim_set_hl(0, "Cursor", { bg = "#ff007b" })
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
        vim.api.nvim_set_hl(0, "Pmenu", { link = "Normal" })
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
              ALAI = { icon = "📝", color = "#ff007b" }
            }
        },
    },
    {
      'echasnovski/mini.ai',
      version = false,
      config = function()
        require('mini.ai').setup({
          n_lines = 500
        })
      end
    },
    {
      'echasnovski/mini.splitjoin',
      version = false,
      opts = {}
    },
}

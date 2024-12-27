return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require"nvim-treesitter.configs".setup({
        ensure_installed = {
          "c",
          "cpp",
          "css",
          "html",
          "lua",
          "markdown",
          "markdown_inline",
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
          enable = false,
        },
        matchup = { -- vim-matchup, see `matchup.lua`
          enable = true,
        },
      })

      -- Enable indenting only for PHP files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "php",
        callback = function()
          require("nvim-treesitter.configs").setup({
            indent = { enable = true }
          })
        end,
      })
    end
  }
}

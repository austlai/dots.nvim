return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      },
      win_options = {
        wrap = false,
        signcolumn = "no",
      },
      float = {
        border = "single",
        preview_split = "right"
      },
      keymaps = {
        ["gp"] = { "actions.copy_entry_path", mode = "n" },
      }
    })

    vim.keymap.set("n", "go", require('oil').toggle_float, { desc = "Toggle Oil" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",
      callback = vim.schedule_wrap(function(args)
        local oil = require("oil")
        if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
          oil.open_preview()
        end
      end),
    })
  end
}

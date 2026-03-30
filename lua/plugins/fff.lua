return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = {
    keymaps = {
      move_up = { '<Up>', '<C-k>' },
      move_down = { '<Down>', '<C-j>' },
      preview_scroll_up = '<C-b>',
      preview_scroll_down = '<C-f>',
    }
  },
  lazy = false,
  keys = {
    {
      "<C-f>",
      function() require('fff').find_files() end,
    },
  }
}

return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = { },
  lazy = false,
  keys = {
    {
      "<C-f>", -- try it if you didn't it is a banger keybinding for a picker
      function() require('fff').find_files() end,
    },
    {
      "<C-g>",
      function() require('fff').live_grep() end,
    },
  }
}

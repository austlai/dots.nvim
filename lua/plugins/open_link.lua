return {
  "alaifln/open-link.nvim",
  init = function()
    local expanders = require("open-link.expanders")
    require("open-link").setup({
      expanders = {
        expanders.phab("https://phabricator.tools.flnltd.com/", { "D", "T"})
      },
    })
  end,
  cmd = { "OpenLink" },
  keys = {
    {
      "gp",
      "<cmd>OpenLink<cr>",
      desc = "Open the link under the cursor"
    }
  }
}

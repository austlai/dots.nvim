vim.pack.add({
  'https://github.com/mbbill/undotree',
  'https://github.com/alaifln/open-link.nvim',
})

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Open Link
local expanders = require("open-link.expanders")
require("open-link").setup({
  expanders = {
    expanders.phab("https://phabricator.tools.flnltd.com/", { "D", "T" }),
  },
})
vim.keymap.set("n", "gp", "<cmd>OpenLink<cr>", { desc = "Open the link under the cursor" })

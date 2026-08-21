vim.pack.add({
  'https://github.com/alaifln/open-link.nvim',
})

-- Open Link. Expanders are registered by whatever is on the runtimepath via
-- open-link's addExpanders(), so none are configured here.
require("open-link").setup({})
vim.keymap.set("n", "gp", "<cmd>OpenLink<cr>", { desc = "Open the link under the cursor" })

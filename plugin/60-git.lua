vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/lionyxml/gitlineage.nvim',
})

-- Gitsigns
local gitsigns = require("gitsigns")
gitsigns.setup()

vim.keymap.set("n", "]g", function() gitsigns.nav_hunk('next') end, { desc = "Next Hunk" })
vim.keymap.set("n", "[g", function() gitsigns.nav_hunk('prev') end, { desc = "Prev Hunk" })
vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })

-- Diffview
require("diffview").setup({})

-- Git Lineage
require("gitlineage").setup({
  keymap = "<leader>bl",
  keys = {
    close = "<Esc>",
    next_commit = "<C-n>",
    prev_commit = "<C-p>",
    yank_commit = "y",
    open_diff = "d",
  },
})

vim.pack.add({
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/folke/ts-comments.nvim',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/andymass/vim-matchup',
  'https://github.com/folke/flash.nvim',
})

-- Autopairs
require("nvim-autopairs").setup({})

-- Surround
require("nvim-surround").setup()

-- Comments
require("ts-comments").setup({})

-- Autotag
require("nvim-ts-autotag").setup()

-- Matchup
vim.g.matchup_matchparen_offscreen = { method = "popup" }

-- Flash
require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

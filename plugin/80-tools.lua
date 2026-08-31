vim.pack.add({
  'https://github.com/alaifln/open-link.nvim',
})

-- Open Link. Expanders are registered by whatever is on the runtimepath via
-- open-link's addExpanders(), so none are configured here.
require("open-link").setup({})
vim.keymap.set("n", "gp", "<cmd>OpenLink<cr>", { desc = "Open the link under the cursor" })

-- Tell snacks.image the outer terminal is kitty. It can't detect that
-- itself here: tmux has extended-keys on, so snacks falls back to tmux's
-- #{client_termname}, and kitty.conf presents "term xterm-256color" (kept
-- for ssh compatibility) -- leaving kitty unrecognized and image rendering
-- silently disabled. SNACKS_<NAME> is snacks' own detection override.
vim.env.SNACKS_KITTY = '1'

-- Arcanist / Phorge integration, loaded from the local working copy so
-- edits there take effect on restart (not managed by vim.pack -- that would
-- clone a snapshot). After grammar changes, rebuild the parser with `make`
-- in the repo.
local arcanist = vim.fs.normalize('~/external-repos/arcanist.nvim')
vim.opt.runtimepath:prepend(arcanist)
vim.opt.runtimepath:append(arcanist .. '/after')

-- We're inside the plugin-loading phase already, so source its plugin and
-- ftdetect files explicitly; the vim.g.loaded_arcanist guard makes a second
-- pass over the plugin file a no-op, and the ftdetect file only calls
-- vim.filetype.add(), which is safe to repeat.
vim.cmd.runtime({ 'plugin/arcanist.lua', bang = true })
vim.cmd.runtime({ 'ftdetect/*.lua', bang = true })

require('arcanist').setup({
  image = { max_height = 20 }, -- terminal rows; width stays at snacks' 80-col default
})

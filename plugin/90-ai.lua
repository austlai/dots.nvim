vim.pack.add({
  'https://github.com/folke/sidekick.nvim',
  'https://github.com/ThePrimeagen/99',
})

-- Sidekick
require("sidekick").setup({
  nes = {
    enabled = false,
  },
})

vim.keymap.set("n", "<C-y>", function()
  if require("sidekick").nes_jump_or_apply() then
    return
  end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "x", "n" }, "<leader>ct", function()
  require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

vim.keymap.set({ "n", "x" }, "<leader>cp", function()
  require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

vim.keymap.set("n", "<leader>cc", function()
  require("sidekick.cli").toggle({ focus = true })
end, { desc = "Sidekick Toggle Cli" })

-- 99 (Claude Code)
local _99 = require("99")
local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)

_99.setup({
  provider = _99.Providers.ClaudeCodeProvider,
  logger = {
    level = _99.DEBUG,
    path = "/tmp/" .. basename .. ".99.debug",
    print_on_error = true,
  },
  tmp_dir = "./.cache/99/tmp/",
  md_files = {
    "AGENT.md",
    "CLAUDE.md",
  },
})

vim.keymap.set("v", "<leader>9v", function() _99.visual() end)
vim.keymap.set("n", "<leader>9x", function() _99.stop_all_requests() end)
vim.keymap.set("n", "<leader>9s", function() _99.search() end)

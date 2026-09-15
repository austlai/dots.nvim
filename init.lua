vim.loader.enable()

-- Optional private overlay. Appended, not prepended: its lsp/ and plugin/ files
-- have to resolve after this config's own for its overrides to win.
local overlay = vim.fn.expand("~/utils/fln-nvim")
if vim.fn.isdirectory(overlay) == 1 then
  vim.opt.runtimepath:append(overlay)
end

-- Per-directory config (.nvim.lua in cwd or a parent, once :trust-ed).
vim.o.exrc = true

require("options")
require("mappings")
require("commands")
require("remarkup").setup()

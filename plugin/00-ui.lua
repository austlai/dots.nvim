vim.pack.add({
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/vague-theme/vague.nvim',
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  'https://github.com/wtfox/jellybeans.nvim',
  { src = 'https://github.com/projekt0n/github-nvim-theme', name = 'github-theme' },
  'https://github.com/ramojus/mellifluous.nvim',
  'https://github.com/sainnhe/edge',
  'https://github.com/miikanissi/modus-themes.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/sainnhe/everforest',
})

vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/echasnovski/mini.ai',
  'https://github.com/echasnovski/mini.splitjoin',
})

-- Colorschemes
require("rose-pine").setup({
  dim_inactive_windows = true,
  highlight_groups = {
    CurSearch = { fg = "base", bg = "leaf", inherit = false },
    Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
  },
})

require("jellybeans").setup({
  -- flat_ui paints FloatBorder with fg == bg, so borders render as a solid slab
  -- instead of line-drawing characters. Off = real single-line borders.
  flat_ui = false,
  -- plugins.auto only detects plugins through lazy.nvim, which we don't use, so
  -- BlinkCmp*/Snacks*/etc. would silently never be defined.
  plugins = { all = true },
})

vim.g.edge_enable_italic = true
vim.g.everforest_enable_italic = true

-- Reapply custom highlights whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { bg = "#ff007b" })
  end,
})

vim.cmd.colorscheme("jellybeans")
vim.opt.guicursor = "n-c-v:block,i:-ver10,a:Cursor/lCursor"

-- Lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "jellybeans",
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
    padding = 2,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "diagnostics" },
    lualine_x = { { "filename", path = 1 } },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = {},
})

-- Fidget
require("fidget").setup({})

-- Todo Comments
require("todo-comments").setup({
  keywords = {
    ALAI = { icon = "\xF0\x9F\x93\x9D", color = "#ff007b" },
  },
})

-- Mini
require("mini.ai").setup({
  n_lines = 500,
  -- don't shadow nvim 0.12's built-in an/in incremental selection mappings
  mappings = { around_next = '', inside_next = '' },
})
require("mini.splitjoin").setup({})

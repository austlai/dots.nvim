vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
})

-- Conform
require("conform").setup({
  formatters_by_ft = {
    typescript = { "prettierd", "prettier", stop_after_first = true },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("", "<leader>F", function()
  require("conform").format({ async = true })
  if vim.fn.exists(":EslintFixAll") == 2 then
    vim.cmd("EslintFixAll")
  end
end, { desc = "Format buffer" })

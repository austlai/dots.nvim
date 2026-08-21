vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
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

-- Lint
local lint = require("lint")

-- phpstan is proxied by phpantom (editor mode, on save) — see .phpantom.toml
lint.linters_by_ft = {
  php = {
    -- "phpcs",
  },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})

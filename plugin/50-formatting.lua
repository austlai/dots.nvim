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
  vim.cmd("EslintFixAll")
end, { desc = "Format buffer" })

-- Lint
local lint = require("lint")

local phpcs = lint.linters.phpcs
phpcs.cmd = "./vendor/bin/phpcs"
phpcs.args = {
  "-q",
  "--report=json",
  "--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml",
  "-",
}

local phpstan = lint.linters.phpstan
phpstan.cmd = "./vendor/bin/phpstan"
phpstan.args = {
  'analyse',
  '--no-progress',
  '--error-format=json',
  '--memory-limit=-1',
  '--no-ansi',
  '--no-interaction',
  '--configuration=/home/alai/freelancer-dev/fl-gaf/phpstan.neon',
}

lint.linters_by_ft = {
  php = {
    -- "phpcs",
    "phpstan"
  },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})

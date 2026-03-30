return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    local phpcs = lint.linters.phpcs
    phpcs.cmd = "./vendor/bin/phpcs"
    phpcs.args = {
      "-q",
      "--report=json",
      "--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml",
      "-", -- need `-` at the end for stdin support
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
      php = { "phpcs", "phpstan" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

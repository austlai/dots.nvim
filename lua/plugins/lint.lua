return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- NOTE: Not working, setup with phpactor lsp instead...
    -- lint.linters.psalm = {
    --   cmd = "./vendor/bin/psalm",
    --   args = {
    --     "--output-format=json",
    --     "--show-info=true",
    --     "--no-progress",
    --     "--threads=16",
    --     "--config=/home/alai/freelancer-dev/fl-gaf/psalm.xml",
    --     "--use-baseline=/home/alai/freelancer-dev/fl-gaf/psalm-baseline.xml"
    --   },
    -- }

    lint.linters.phpcs = {
      cmd = "./vendor/bin/phpcs",
      args = {
        "-q",
        "--report=json",
        "--standard=/home/alai/freelancer-dev/fl-gaf/phpcs_gaf.xml",
        "-", -- need `-` at the end for stdin support
      },
    }

    lint.linters_by_ft = {
      php = { "phpcs" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

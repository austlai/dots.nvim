return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/external-repos/vscode-php-debug/out/phpDebug.js" }
      }

      dap.configurations.php = {
        {
          name = "Neovim Remote XDebug",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = {
              ["/mnt/gaf"] = os.getenv("HOME") .. "/freelancer-dev/fl-gaf"
          },
          log = true
        },
        {
          name = "Neovim Local XDebug",
          type = "php",
          request = "launch",
          port = 9003,
          log = true
        }
      }

      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F6>', function() require('dapui').toggle() end)
      vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<leader>do', function() dap.step_over() end)
      vim.keymap.set('n', '<leader>di', function() dap.step_into() end)
      vim.keymap.set('n', '<leader>du', function() dap.step_out() end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    event = "VeryLazy",
    opts = {},
  },
}


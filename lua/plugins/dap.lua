return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" }
      }

      dap.configurations.php = {
        {
          name = "Neovim XDebug",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = {
              ["/mnt/gaf"] = os.getenv("HOME") .. "/freelancer-dev/fl-gaf"
          },
          log = true
        }
      }

      vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
      vim.keymap.set('n', '<F6>', function() require('dapui').toggle() end)
      vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
      vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end)
      vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
      vim.keymap.set('n', '<leader>du', function() require('dap').step_out() end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    event = "VeryLazy",
    opts = {},
  },
}


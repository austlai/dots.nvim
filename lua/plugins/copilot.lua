return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_node_command = '/home/alai/.nvm/versions/node/v22.14.0/bin/node'
      })
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      { "<leader>cc", ":CopilotChatToggle<CR>" },
    },
    opts = {
      model = 'claude-3.5-sonnet',
      providers = {
        github_models = { disabled = true },
      },
      mappings = {
        reset = {
          normal = '<C-x>',
          insert = '<C-x>'
        }
      }

    },
  }
}

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
    enabled = false,
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
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
			"j-hui/fidget.nvim",
    },
    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot"
        },
        inline = {
          adapter = "copilot"
        }
      },
      show_defaults = false,
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
			},
    },
    init = function()
      require("plugins.codecompanion.fidget-spinner"):init()
    end,
  },
}

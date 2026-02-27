return {
  "folke/sidekick.nvim",
  config = function()
      require("sidekick").setup()
  end,
  keys = {
    {
      "<C-y>",
      function()
        if require("sidekick").nes_jump_or_apply() then
          return
        end
      end,
      mode = { "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>ct",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>cp",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>cc",
      function() require("sidekick.cli").toggle({ focus = true }) end,
      desc = "Sidekick Toggle Cli",
    },
  },
}

return {
    "lionyxml/gitlineage.nvim",
    dependencies = {
        "sindrets/diffview.nvim",
    },
    config = function()
      require("gitlineage").setup({
        keymap = "<leader>bl",
        keys = {
          close = "<Esc>",
          next_commit = "<C-n>",
          prev_commit = "<C-p>",
          yank_commit = "y",
          open_diff = "d",
        },
      })
    end
}

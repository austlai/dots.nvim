return {
  "Hajime-Suzuki/vuffers.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("vuffers").setup({
      keymaps = {
        use_default = true,
        -- Default Keymaps:
        -- view = {
        --   open = "<CR>",
        --   delete = "d",
        --   pin = "p",
        --   unpin = "P",
        --   rename = "r",
        --   reset_custom_display_name = "R",
        --   reset_custom_display_names = "<leader>R",
        --   move_up = "U",
        --   move_down = "D",
        --   move_to = "i",
        -- },
      },
      sort = {
        type = "none", -- "none" | "filename"
        direction = "asc", -- "asc" | "desc"
      },
    })
    vim.keymap.set("n", "<leader>b", require('vuffers').toggle)
  end,
}

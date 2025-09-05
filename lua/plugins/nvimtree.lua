return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    vim.keymap.set("n", "<Leader>f", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })
    vim.keymap.set("n", "<Leader>s", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find NERDTree" })

    -- Taken from https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#remember-nvimtree-window-size
    require("nvim-tree").setup({
      actions = {
        open_file = {
          resize_window = false,
        }
      },
      view = {
        width = {
          min = -1;
          max = "100%"
        }
      }
    })
  end
}

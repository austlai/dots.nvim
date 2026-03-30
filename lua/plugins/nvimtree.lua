return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    vim.keymap.set("n", "<Leader>f", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })
    vim.keymap.set("n", "<Leader>s", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find NERDTree" })

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      api.map.on_attach.default(bufnr)
      vim.keymap.del("n", "s", { buffer = bufnr })
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
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

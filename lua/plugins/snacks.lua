return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      previewers = { git = { native = true } },
      formatters = { file = { filename_first = true } },
      layout = {
        cycle = false,
        reverse = true,
        layout = {
          box = "horizontal",
          backdrop = false,
          width = 0.8,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = "single" },
            { win = "input", height = 1, border = "single", title = "{source} {live}", title_pos = "center" },
          },
          {
            win = "preview",
            width = 0.45,
            border = "single",
            title = " Preview ",
            title_pos = "center",
          },
        },
      },
    },
  },
  keys ={
    { "<C-g>", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<C-b>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>g", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>p", function() Snacks.picker.resume() end, desc = "Previous Picker" },
    { "<C-f>", function() Snacks.picker.smart({ supports_live = true }) end, desc = "Find Files" },
    { "<leader>j", function() Snacks.picker.jumps() end, desc = "Jump list" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definition" },
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    {
      "<leader>r",
      function()
        Snacks.picker.recent({
          filter = {
            paths = {
              [vim.fn.stdpath("data")] = false,
              [vim.fn.stdpath("cache")] = false,
              [vim.fn.stdpath("state")] = false,
              [vim.fn.stdpath("config")] = false,
              ["/home/alai/freelancer-dev"] = true,
            },
          },
        })
      end,
      desc = "Recent"
    },
  }
}

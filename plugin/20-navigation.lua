vim.pack.add({
  'https://github.com/folke/snacks.nvim',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/epheien/outline-treesitter-provider.nvim',
  'https://github.com/hedyhli/outline.nvim',
})

require("snacks").setup({
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
})

vim.keymap.set("n", "<C-g>", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<C-f>", function() Snacks.picker.files() end, { desc = "Files" })
vim.keymap.set("n", "<leader>g", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>p", function() Snacks.picker.resume() end, { desc = "Previous Picker" })
vim.keymap.set("n", "<leader>j", function() Snacks.picker.jumps() end, { desc = "Jump list" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "LSP References" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "LSP Definition" })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "LSP Implementations" })
vim.keymap.set("n", "<leader>ls", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>z", function() Snacks.picker.zoxide() end, { desc = "Zoxide" })
vim.keymap.set("n", "<leader>t", function() Snacks.picker.todo_comments({ keywords = { "ALAI" } }) end, { desc = "ALAI Comments" })
vim.keymap.set("n", "<leader>r", function()
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
end, { desc = "Recent" })

local function nvimtree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.map.on_attach.default(bufnr)
  vim.keymap.del("n", "s", { buffer = bufnr })
end

require("nvim-tree").setup({
  on_attach = nvimtree_on_attach,
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  view = {
    width = {
      min = -1,
      max = "100%",
    },
  },
})

vim.keymap.set("n", "<Leader>f", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
vim.keymap.set("n", "<Leader>s", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find in NvimTree" })

local oil = require("oil")
oil.setup({
  view_options = {
    show_hidden = true,
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
  },
  float = {
    border = "single",
    preview_split = "right",
  },
  keymaps = {
    ["gp"] = {
      callback = function()
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then
          return
        end
        local relpath = vim.fn.fnamemodify(dir, ":.")
        vim.fn.setreg("+", relpath .. entry.name)
      end,
      mode = "n",
    },
  },
})

vim.keymap.set("n", "go", oil.toggle_float, { desc = "Toggle Oil" })

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local o = require("oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and o.get_cursor_entry() then
      o.open_preview()
    end
  end),
})

vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
require("outline").setup({
  outline_window = {
    position = 'left',
    no_provider_message = ''
  },
  symbol_folding = {
    autofold_depth = false,
  },
  providers = {
    priority = { 'lsp', 'markdown', 'man', 'treesitter' }
  },
})

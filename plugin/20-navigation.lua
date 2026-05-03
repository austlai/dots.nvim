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
    matcher = {
      frecency = true
    },
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
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers({ hidden = true }) end, { desc = "Buffers" })
vim.keymap.set("n", "<C-f>", function() Snacks.picker.files({ hidden = true }) end, { desc = "Files" })
vim.keymap.set("n", "<leader>g", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>bl", function() Snacks.picker.git_log_file() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>p", function() Snacks.picker.resume() end, { desc = "Previous Picker" })
vim.keymap.set("n", "<leader>j", function() Snacks.picker.jumps() end, { desc = "Jump list" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "LSP References" })

local function goto_definition_race()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
  if #clients == 0 then
    vim.notify("No LSP client supports definition", vim.log.levels.WARN)
    return
  end

  local done = false
  local pending = {}
  local errors = 0
  local empties = 0
  local total = #clients

  local function cancel_others(winner_id)
    for c, id in pairs(pending) do
      if c.id ~= winner_id then
        pcall(function() c:cancel_request(id) end)
      end
    end
  end

  for _, client in ipairs(clients) do
    local enc = client.offset_encoding
    local params = vim.lsp.util.make_position_params(0, enc)
    local ok, req_id = client:request("textDocument/definition", params, function(err, result)
      if done then return end
      if err then
        errors = errors + 1
        if errors + empties == total then
          done = true
          vim.notify("All definition requests failed", vim.log.levels.WARN)
        end
        return
      end
      if not result or (vim.islist(result) and #result == 0) then
        empties = empties + 1
        if errors + empties == total then
          done = true
          vim.notify("No definition found", vim.log.levels.WARN)
        end
        return
      end
      done = true
      cancel_others(client.id)
      local loc = vim.islist(result) and result[1] or result
      vim.lsp.util.show_document(loc, enc, { focus = true })
    end, 0)
    if ok then pending[client] = req_id end
  end

  vim.defer_fn(function()
    if not done then
      done = true
      cancel_others(-1)
      vim.notify("Definition request timed out", vim.log.levels.WARN)
    end
  end, 2000)
end

vim.keymap.set("n", "gd", goto_definition_race, { desc = "LSP Definition (race)" })
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

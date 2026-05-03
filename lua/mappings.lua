-- Keymaps --

local set = vim.keymap.set

-- Add numbered jumps to the jumplist
set({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

set({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

set("i", "jk", "<esc>", { desc = "Set jk as escape" })
set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Fix spelling mistakes in line" })
set("n", "<C-h>", "<C-w>h", { desc = "Move to different window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move to different window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move to different window" })
set('n', '<M-=>', ':vertical res +5<CR>', { desc = 'Resizing vertical windows' })
set('n', '<M-->', ':vertical res -5<CR>', { desc = 'Resizing vertical windows' })
set("n", "<C-l>", "<C-w>l", { desc = "Move to different window" })
set("v", "<", "<gv", { desc = "Move indentation of block" })
set("v", ">", ">gv", { desc = "Move indentation of block" })
set("v", "J", [[:m ">+1<CR>gv=gv]], { desc = "Moves selected lines down" })
set("v", "K", [[:m "<-2<CR>gv=gv]], { desc = "Moves selected lines up" })
set("", "Q", "<Nop>", { desc = "Removes Ex mode" })
set('n', '/', "/\\v", { desc = 'regex' })
set('v', '/', "/\\v", { desc = 'regex' })
set('c', 's/', "s/\\v", { desc = 'regex' })
set('c', '%s/', "%s/\\v", { desc = 'regex' })
set('n', 'n', 'nzz', { desc = 'center next search' })
set('n', '<Leader>cn', ':cnext<CR>', { desc = 'Next quickfix entry' })
set('n', '<Leader>cp', ':cprev<CR>', { desc = 'Prev quickfix entry' })
set('n', '<Leader>J', '<cmd>Treewalker Down<cr>', { silent = false })
set('n', '<Leader>K', '<cmd>Treewalker Up<cr>', { silent = false })
set('n', '<Leader>L', '<cmd>Treewalker Right<cr>', { silent = false })
set('n', '<Leader>H', '<cmd>Treewalker Left<cr>', { silent = false })
set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { silent = true, noremap = true })

set({ 'n', 'x' }, '<Leader>yp', function()
  local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local mode = vim.fn.mode()
  local suffix
  if mode == 'v' or mode == 'V' then
    local s, e = vim.fn.line('v'), vim.fn.line('.')
    if s > e then s, e = e, s end
    suffix = (s == e) and (':' .. s) or (':' .. s .. '-' .. e)
  else
    suffix = ':' .. vim.fn.line('.')
  end

  local parts = {}
  local node = vim.treesitter.get_node()
  while node do
    local t = node:type()
    if t:match('function') or t:match('method') or t:match('class') then
      local name = node:field('name')[1]
      if name then table.insert(parts, 1, vim.treesitter.get_node_text(name, 0)) end
    end
    node = node:parent()
  end

  local items = { rel .. suffix }
  if #parts > 0 then
    table.insert(items, table.concat(parts, '::') .. suffix)
  end

  vim.ui.select(
    items,
    {
      prompt = 'Copy path:',
      snacks = { layout = { preset = 'select', preview = false } },
    },
    function(choice)
      if choice then vim.fn.setreg('+', choice) end
    end
  )
end, { desc = 'Yank file path / symbol path' })



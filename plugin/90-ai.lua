vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'neocursor.nvim' then return end
    if ev.data.kind == 'install' or ev.data.kind == 'update' then
      vim.system({ 'uv', 'run', '--with', 'httpx[http2]', 'python', '-c', 'import httpx' })
    end
  end,
})

-- Local checkout wins when it's there, upstream otherwise. The blink source
-- (neocursor.blink) and the `render` option only exist in the patched tree.
local dev = vim.fn.expand('~/external-repos/neocursor.nvim')
if vim.fn.isdirectory(dev) == 1 then
  vim.opt.runtimepath:prepend(dev)
else
  vim.pack.add({ 'https://github.com/teocns/neocursor.nvim' })
end

local started = false
local function ensure()
  if started then return end
  started = true

  require('neocursor').setup({
    map_tab     = false, -- blink.cmp owns <Tab>
    map_partial = false, -- no <M-Right> word-at-a-time accept
    show_hints  = false, -- the pill hardcodes "<Tab> accept"
    -- inline ghosts are drawn by blink.cmp instead (see the neocursor provider
    -- in 40-lsp.lua); diff overlays and jump pills still paint natively
    render      = { inline = false },
  })

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      pcall(vim.api.nvim_exec_autocmds, 'BufEnter', { group = 'neocursor', buffer = b })
    end
  end
end

vim.api.nvim_create_autocmd('InsertEnter', { once = true, callback = ensure })

-- Insert mode too: unmapped, <C-q> is vim's i_CTRL-Q (an alias for i_CTRL-V,
-- quote-next-literally), which is where the stray ^Q came from. accept() covers
-- inline-accept, diff-accept, jump-to-edit and jump-to-prediction in one call.
vim.keymap.set({ 'n', 'i' }, '<C-q>', function()
  ensure()
  local nc = require('neocursor')
  if nc.accept() then
    pcall(function() require('blink.cmp').hide() end)
    return
  end
  nc.suggest()
end, { desc = 'neocursor: next edit (fetch / jump / accept)' })

vim.keymap.set('n', '<leader>N', function()
  ensure()
  require('neocursor').dismiss()
end, { desc = 'neocursor: dismiss suggestion' })

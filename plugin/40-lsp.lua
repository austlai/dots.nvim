vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/Bilal2453/luvit-meta',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antosha417/nvim-lsp-file-operations',
  'https://github.com/b0o/SchemaStore.nvim',
})

require("mason").setup()

vim.diagnostic.config({
  float = { source = true },
})

-- Handle vscode.open command for phpantom code lens
vim.lsp.commands['vscode.open'] = function(command)
  local uri = command.arguments[1]
  local fragment = uri:match('#(.+)$')
  local file = vim.uri_to_fname(uri:gsub('#.+$', ''))
  vim.cmd.edit(file)
  if fragment then
    local line, col = fragment:match('L(%d+),(%d+)')
    if line then
      vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
      vim.cmd('normal! zz')
    end
  end
end

-- LSP keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { noremap = true, buffer = ev.buf, silent = true }
    vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })) end, opts)
    vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)

    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.lsp.codelens.enable(true, { bufnr = ev.buf })
      end
    end, 1000)
  end,
})

-- Blink.cmp capabilities for all LSP servers
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Enable LSP servers
vim.lsp.enable({
  'clangd',
  'cssls',
  'eslint',
  'gopls',
  'hls',
  'html',
  'intelephense',
  'jsonls',
  'lua_ls',
  'marksman',
  'phpactor',
  'phpantom',
  'puppet',
  'taplo',
  'thriftls',
  'ty',
  'vtsls',
  'yamlls',
})

-- Blink.cmp + LuaSnip (deferred to InsertEnter for startup speed)
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    local luasnip = require("luasnip")
    luasnip.filetype_extend("typescript", { "angular", "tsdoc" })
    luasnip.filetype_extend("php", { "phpdoc" })
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

    require('blink.cmp').setup({
      enabled = function()
        return vim.bo.buftype ~= 'prompt'
      end,
      keymap = { preset = 'default' },
      fuzzy = {
        implementation = 'lua',
        sorts = { 'exact', 'score', 'sort_text' },
      },
      completion = {
        menu = {
          enabled = true,
          border = 'single',
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind" } },
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = 'single',
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = 'single',
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      snippets = { preset = 'luasnip' },
      sources = {
        providers = {
          lsp = {
            score_offset = 80,
            async = true,
          },
        },
        default = { "lsp", "path", "snippets", "buffer" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
    })
  end,
})

-- Lazydev (deferred to lua files)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  once = true,
  callback = function()
    require("lazydev").setup({
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    })
  end,
})

-- LSP File Operations
require("lsp-file-operations").setup()

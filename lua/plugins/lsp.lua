return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Global capabilities for all servers
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- LspAttach autocmd for keybindings and navbuddy
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { noremap = true, buffer = ev.buf, silent = true }
          vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = 1, float = true}) end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = -1, float = true}) end, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
      })

      vim.lsp.enable({
        'html',
        'cssls',
        'clangd',
        'lua_ls',
        -- 'basedpyright',
        'eslint',
        'marksman',
        'intelephense',
        'thriftls',
        'phpactor',
        'hls',
        'gopls',
        'puppet',
        'vtsls',
        'ty',
      })
    end
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}

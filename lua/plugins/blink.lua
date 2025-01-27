return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      completion = {
        menu = {
          enabled = true,
          border = 'single',
        },
        documentation = {
          auto_show = true,
          window = {
            border = 'single',
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = 'single',
        },
      },
      snippets = { preset = 'luasnip' },
      sources = {
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
          snippets = {
            score_offset = 101 -- Prefer snippets over copilot
          }
        },
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
    },
    -- opts_extend = { "sources.default" },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.filetype_extend("typescript", {
        "angular",
        "tsdoc"
      })
      luasnip.filetype_extend("php", {
        "phpdoc"
      })
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      require('blink.cmp').setup(opts)
    end
  }
}

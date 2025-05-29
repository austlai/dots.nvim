return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'fang2hou/blink-copilot',
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    version = '*',
    lazy = true,
    event = 'InsertEnter',
    opts = {
      keymap = { preset = 'default' },
      fuzzy = {
        sorts = {
          'exact',
          'score',
          'sort_text'
        }
      },
      completion = {
        menu = {
          enabled = true,
          border = 'single',
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind" } },
            treesitter = { 'lsp' },
          }
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
            async = true
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
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

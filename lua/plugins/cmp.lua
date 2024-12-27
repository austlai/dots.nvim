return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    },
    version = 'v0.*',
    config = function()
      local luasnip = require("luasnip")
      luasnip.filetype_extend("typescript", {
          "angular",
          "tsdoc"
      })
      luasnip.filetype_extend("php", {
          "phpdoc"
      })
      require("luasnip.loaders.from_vscode").lazy_load()
      require('blink.cmp').setup({
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
        snippets = {
          expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
          active = function(filter)
            if filter and filter.direction then
              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction) require('luasnip').jump(direction) end,
        },
        sources = {
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 100,
              async = true,
            },
          },
          completion = {
            enabled_providers = { "lsp", "path", "snippets", "luasnip", "buffer", "copilot" },
          },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono',
        },
        opts_extend = { "sources.default" }
      })
    end
  }
}

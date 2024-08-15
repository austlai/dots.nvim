return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
        "zbirenbaum/copilot-cmp",
    },
    config = function()
        local luasnip = require("luasnip")
        luasnip.filetype_extend("typescript", {"angular"})
        require("luasnip.loaders.from_vscode").lazy_load()
        require("copilot_cmp").setup()

        local cmp = require("cmp")
        cmp.setup({
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-e>"] = cmp.mapping.close(),
                ["<C-space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and cmp.get_selected_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ["<C-j>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
                ["<C-k>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = {
                { name = "nvim_lsp", priority = 100 },
                { name = "luasnip", priority = 90 },
                { name = "copilot", priority = 80 },
                { name = "buffer" },
                { name = "path" },
                { name = "spell", keyword_length = 3 },
            },
            window = {
                completion = cmp.config.window.bordered({ border = "single" }),
                documentation = cmp.config.window.bordered({ border = "single" }),
            },
            formatting = {
                format = require("lspkind").cmp_format({
                    maxwidth = 50,
                    with_text = true,
                    menu = {
                        nvim_lsp = "[LSP]",
                        path = "[Path]",
                        buffer = "[Buffer]",
                        spell = "[Spell]",
                        luasnip = "[Snip]",
                        copilot = "[Copilot]",
                    },
                }),
            },
            experimental = {
                ghost_text = false
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources(
                {
                    { name = "path" }
                },
                {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" }
                        }
                    }
                }
            )
        })

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })
    end,
}

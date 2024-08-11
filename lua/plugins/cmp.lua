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
        require("luasnip").filetype_extend("typescript", {"angular"})
        require("luasnip.loaders.from_vscode").lazy_load()
        require("copilot_cmp").setup()

        local has_words_before = function()
            if vim.api.nvim_get_option_value("buftype", {buf=0}) == "prompt" then
                return false
            end
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require("cmp")
        cmp.setup({
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-u>"] = cmp.mapping.scroll_docs(4),
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
                    if vim.snippet.active({ direction = 1 }) then
                        vim.schedule(function()
                            vim.snippet.jump(1)
                        end)
                    elseif cmp.visible() and has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if vim.snippet.active({ direction = -1 }) then
                        vim.schedule(function()
                            vim.snippet.jump(-1)
                        end)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "copilot" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
                { name = "spell", keyword_length = 3 },
            },
            window = {
                -- #borderssuck
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
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
                ghost_text = true
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

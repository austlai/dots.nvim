return {
    "folke/ts-comments.nvim",
    opts = {
        lang = {
            typescript = {
                "/** %s */",
                "// %s"
            }
        }
    },
    event = "VeryLazy",
}

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup()

        vim.keymap.set("n", "]g", function() gitsigns.nav_hunk('next') end, { desc = "Next Hunk" })
        vim.keymap.set("n", "[g", function() gitsigns.nav_hunk('prev') end, { desc = "Prev Hunk" })
        vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
    end,
}

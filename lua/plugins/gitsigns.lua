return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup()

        vim.keymap.set("n", "<leader>hn", gitsigns.next_hunk, { desc = "Next Hunk" })
        vim.keymap.set("n", "<leader>hp", gitsigns.prev_hunk, { desc = "Prev Hunk" })
        vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
    end,
}

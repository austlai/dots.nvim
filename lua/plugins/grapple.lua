return {
    "cbochs/grapple.nvim",
    opts = {
        scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
        { "<leader>ta", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag", silent = false },
        { "<leader>tl", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
    },
}

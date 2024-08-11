return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf_lua = require("fzf-lua")

        fzf_lua.setup({
            winopts = {
                border = "single"
            },
            fzf_opts = {
                ["--layout"] = "default"
            },
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept"
                }
            }
        })

        vim.keymap.set("n", "<C-f>", function() fzf_lua.files({ resume = true }) end, {})
        vim.keymap.set("n", "<C-g>", function() fzf_lua.live_grep({ resume = true }) end, {})
        vim.keymap.set("n", "<C-b>", fzf_lua.buffers, {})
        vim.keymap.set("n", "<leader>g", fzf_lua.git_status, {})
    end
}

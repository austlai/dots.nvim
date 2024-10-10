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
                ["--layout"] = "default",
            },
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept"
                }
            },
            grep = {
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --multiline -e",
            }
        })

        vim.keymap.set("n", "<C-f>", function()
            fzf_lua.files({
                resume = true,
                cwd_prompt = false,
                multiprocess = true,
            })
        end, {})
        vim.keymap.set("n", "<C-g>", function() fzf_lua.live_grep({ multiprocess = true, resume = true }) end, {})
        vim.keymap.set("n", "<C-b>", fzf_lua.buffers, {})
        vim.keymap.set("n", "<leader>g", fzf_lua.git_status, {})
    end
}

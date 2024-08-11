return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        vim.keymap.set("n", "<Leader>f", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })
        vim.keymap.set("n", "<Leader>s", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find NERDTree" })

        -- Taken from https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#remember-nvimtree-window-size
        require("nvim-tree").setup({
            actions = {
                open_file = {
                    resize_window = false,
                }
            }
        })

        local view = require("nvim-tree.view")
        local api = require("nvim-tree.api")
        local augroup = vim.api.nvim_create_augroup
        local autocmd = vim.api.nvim_create_autocmd

        -- save nvim-tree window width on WinResized event
        augroup("save_nvim_tree_width", { clear = true })
        autocmd("WinResized", {
            group = "save_nvim_tree_width",
            pattern = "*",
            callback = function()
                local filetree_winnr = view.get_winnr()
                if filetree_winnr ~= nil and vim.tbl_contains(vim.v.event["windows"], filetree_winnr) then
                    vim.t["filetree_width"] = vim.api.nvim_win_get_width(filetree_winnr)
                end
            end,
        })

        -- restore window size when openning nvim-tree
        api.events.subscribe(api.events.Event.TreeOpen, function()
            if vim.t["filetree_width"] ~= nil then
                view.resize(vim.t["filetree_width"])
            end
        end)
    end
}

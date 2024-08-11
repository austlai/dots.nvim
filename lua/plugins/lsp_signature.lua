return {
    "ray-x/lsp_signature.nvim",
    config = function()
        require "lsp_signature".setup({
            floating_window_above_cur_line = true,
            hint_enable = false,
            doc_lines = 0,
            handler_opts = {
                border = "none"
            }
        })
    end
}

return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        vim.cmd("hi! IblScope guifg=#938056")

        require("ibl").setup({
            scope = {
                show_start = false,
                show_end = false
            }
        })

        local hooks = require("ibl.hooks")
        hooks.register(
            hooks.type.WHITESPACE,
            hooks.builtin.hide_first_space_indent_level
        )
    end
}

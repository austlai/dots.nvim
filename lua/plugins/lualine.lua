return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup {
            options = {
                icons_enabled = true,
                theme = "kanagawa",
                component_separators = "",
                section_separators = "",
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = false,
                padding = 2,
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch", "diff"},
                lualine_c = {"diagnostics"},
                lualine_x = {{"filename", path = 1}},
                lualine_y = {"progress"},
                lualine_z = {"location"}
            },
            extensions = {}
        }
    end
}

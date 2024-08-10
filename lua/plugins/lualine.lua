-- lualine --

return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local diagnostics = guifg=#202020{
          "diagnostics",
          colored = false,
        }

        vim.cmd("hi! IblScope guifg=#202020")

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = "",
                section_separators = "",
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = false,
                padding = 2,
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff'},
                lualine_c = {diagnostics},
                lualine_x = {'filename'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            extensions = {}
        }
    end
}

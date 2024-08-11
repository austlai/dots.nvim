-- Commands --

local api = vim.api

-- toggle relative line numbers
local numberToggleGroup = api.nvim_create_augroup("numberToggle", {clear = true})
api.nvim_create_autocmd(
    {"BufEnter", "FocusGained", "InsertLeave", "WinEnter"},
    {
        command = "if &nu && mode() != 'i' | set rnu | endif",
        group = numberToggleGroup,
        desc = "Sets number line to relative",
    }
)
api.nvim_create_autocmd(
    {"BufLeave", "FocusLost", "InsertEnter", "WinLeave"},
    {
        command = "if &nu | set nornu | endif",
        group = numberToggleGroup,
        desc = "Sets number line to nonrelative",
    }
)

-- Remove trailing whitespace
TrimWhitespace = function()
    local current_view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(current_view)
end

vim.api.nvim_create_autocmd("BufWritePre", {
    command = [[lua TrimWhitespace()]],
    desc = "Remove trailing whitespace on write",
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({higroup="Search", timeout=500})
    end
})


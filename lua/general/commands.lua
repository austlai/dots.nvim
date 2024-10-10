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

-- TODO: Fix this
-- 1. Make it actually run on new line
-- 2. Capture the initial indentation and apply it for the new lines
ConvertComment = function()
    local line = vim.api.nvim_get_current_line()
    local comment = line:match('^%s*//%s*(.*)')
    if comment then
        local new_lines = { '/**', ' * ' .. comment, ' */' }
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)
    else
        -- If not a comment, simply execute a normal Enter
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', false)
    end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'php' },
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':lua ConvertComment()<CR>', { noremap = true, silent = true })
    end,
})

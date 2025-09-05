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

api.nvim_create_user_command('Table',
  function(opts)
    local line1 = opts.line1
    local line2 = opts.line2

    vim.cmd(string.format("%d,%d!column -t -s ' ' -o '|'", line1, line2))
  end,
  {
    desc = "Format markdown table",
    range = true,
    nargs = 0
  }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "thrift",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

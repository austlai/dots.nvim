vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "css",
    "groovy",
    "hcl",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "php",
    "phpdoc",
    "php_only",
    "puppet",
    "python",
    "scss",
    "sql",
    "terraform",
    "toml",
    "twig",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zsh",
  },
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    local lang = vim.treesitter.language.get_lang(ft)
    if lang then
      vim.treesitter.start()
    end
  end,
})

-- Enable treesitter indent for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "typescript" },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/aaronik/treewalker.nvim',
})

-- Treesitter Context
require("treesitter-context").setup({
  enable = true,
  multiwindow = false,
})

-- Treewalker
require("treewalker").setup({
  highlight = true,
  highlight_duration = 250,
  highlight_group = "ColorColumn",
})

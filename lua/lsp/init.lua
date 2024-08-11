-- nvim-lsp

require("mason").setup {}
require("mason-lspconfig").setup {
    automatic_installation = {}
}

local nvim_lsp = require('lspconfig')

local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>zz', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('n', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap('n', '<Leader>a', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = "single" })
    vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Language Servers
local lsp_flags = { debounce_text_changes = 150 }
local servers = { 'pyright', 'clangd', 'bashls', 'lua_ls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities
    }
end

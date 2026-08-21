return {
  cmd = { '/home/alai/external-repos/phpantom_lsp/target/release/phpantom_lsp' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  -- see lua/php_root.lua: keeps vendor/ buffers on the project root
  root_dir = require('php_root').resolver('phpantom'),
  -- phpantom (lsp-types 0.94) can only register type hierarchy dynamically,
  -- and nvim doesn't advertise this capability by default
  capabilities = {
    textDocument = { typeHierarchy = { dynamicRegistration = true } },
  },
  on_attach = function(client, bufnr)
    -- Let intelephense handle these
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.foldingRangeProvider = false
    client.server_capabilities.documentLinkProvider = false
    -- Let phpactor handle this (phpantom's is still partial)
    client.server_capabilities.workspaceSymbolProvider = false
  end,
}

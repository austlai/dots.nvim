return {
  cmd = { '/home/alai/external-repos/phpantom_lsp/target/release/phpantom_lsp' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  on_attach = function(client, bufnr)
    -- Let intelephense/phpactor handle these
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.foldingRangeProvider = false
    client.server_capabilities.selectionRangeProvider = false
    client.server_capabilities.documentLinkProvider = false
    client.server_capabilities.typeHierarchyProvider = false
    client.server_capabilities.diagnosticProvider = false
    -- Not supported in Neovim
    client.server_capabilities.linkedEditingRangeProvider = false
  end,
}

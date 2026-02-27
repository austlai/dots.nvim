return {
  on_attach = function(client, bufnr)
    client.server_capabilities.workspaceSymbolProvider = false
  end,
  settings = {
    intelephense = {
      completion = {
        callSnippet = "Replace"
      }
    }
  },
}

return {
  on_attach = function(client, bufnr)
    client.server_capabilities.workspaceSymbolProvider = false
  end,
  settings = {
    intelephense = {
      environment = {
        phpVersion = "8.1"
      },
      completion = {
        callSnippet = "Replace"
      }
    }
  },
}

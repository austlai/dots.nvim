return {
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.completionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.implementationProvider = true
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.diagnosticProvider = false
  end,
  init_options = {
    ["logging.enabled"] = false,
    ["logging.level"] = 'debug',
    ["logging.path"] = 'phpactor.log',
    ["language_server_phpstan.enabled"] = false,
    ["language_server_psalm.enabled"] = true,
    ["language_server_psalm.threads"] = 16,
    ["language_server_psalm.timeout"] = 60,
    ["php_code_sniffer.enabled"] = false,
    ["prophecy.enabled"] = false,
    ["language_server.diagnostic_outsource"] = false,
    ["language_server.diagnostics_on_update"] = false,
  }
}

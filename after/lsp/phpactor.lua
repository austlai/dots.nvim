return {
  -- see lua/php_root.lua: keeps vendor/ buffers on the project root
  root_dir = require('php_root').resolver('phpactor'),
  -- phpactor resolves language_server_psalm.bin to %project_root%/vendor/bin/psalm
  -- and (since 2025.x) runs it as `PHP_BINARY <bin>`. When the root has no
  -- vendor/bin/psalm, php prints "Could not open input file" on *stdout* and
  -- exits 1, which surfaces as the useless
  --   Diagnostic provider "psalm" errored with "Psalm exited with code "1": "
  -- Roots without psalm are common: any non-composer project, and any file
  -- under vendor/<pkg>/ that ships its own composer.json (that becomes the root).
  before_init = function(params, config)
    local opts = vim.deepcopy(config.init_options or {})
    local root = config.root_dir
    local psalm = root and (root .. '/vendor/bin/psalm')
    opts['language_server_psalm.enabled'] = psalm ~= nil and vim.uv.fs_stat(psalm) ~= nil
    params.initializationOptions = opts
  end,
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.completionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.diagnosticProvider = false
    client.server_capabilities.renameProvider = false
  end,
  init_options = {
    ["logging.enabled"] = false,
    ["logging.level"] = 'debug',
    -- relative paths land in the project root; keep it absolute so the log is
    -- always in the same place when logging.enabled is flipped on
    ["logging.path"] = vim.fn.stdpath('state') .. '/phpactor.log',
    ["language_server_phpstan.enabled"] = false,
    ["language_server_psalm.enabled"] = true,
    ["language_server_psalm.threads"] = 16,
    ["language_server_psalm.timeout"] = 60,
    ["php_code_sniffer.enabled"] = false,
    ["prophecy.enabled"] = false,
    ["language_server.diagnostic_outsource"] = false,
    ["language_server.diagnostic_ignore_codes"] = { "worse.docblock_missing_param", "worse.unresolved_name" },
    ["language_server.diagnostics_on_update"] = false,
    -- Setting this key REPLACES phpactor's defaults, so the first three entries
    -- restore them. The last one keeps nested vendor trees (fl-gaf's
    -- support/rector/vendor ships a stubs-rector PHPUnit\Framework\TestCase
    -- with only createMock) from shadowing the real classes in the index.
    ["indexer.exclude_patterns"] = {
      "/vendor/**/Tests/**/*",
      "/vendor/**/tests/**/*",
      "/vendor/composer/**/*",
      "/support/rector/vendor/**/*",
    },
  }
}

-- Mirror fl-gaf's .arclint phpcs severity overrides (error/warning -> advice).
-- phpantom's [phpcs] config has no severity map and hardcodes ERROR -> Error,
-- WARNING -> Warning, but each diagnostic carries the sniff name in `code`
-- (source = "phpcs"), so remap here instead. Arc "advice" ~= Hint.
local gaf_root = '/home/alai/freelancer-dev/fl-gaf'
local gaf_phpcs_advice = {
  -- .arclint "phpcs" linter, PHPCS.E./PHPCS.W. prefixes stripped
  ['SlevomatCodingStandard.TypeHints.ParameterTypeHint.MissingAnyTypeHint'] = true,
  ['SlevomatCodingStandard.TypeHints.ParameterTypeHint.MissingNativeTypeHint'] = true,
  ['SlevomatCodingStandard.TypeHints.ParameterTypeHint.MissingTraversableTypeHintSpecification'] = true,
  ['SlevomatCodingStandard.TypeHints.ReturnTypeHint.MissingAnyTypeHint'] = true,
  ['SlevomatCodingStandard.TypeHints.ReturnTypeHint.MissingNativeTypeHint'] = true,
  ['SlevomatCodingStandard.TypeHints.ReturnTypeHint.MissingTraversableTypeHintSpecification'] = true,
  ['SlevomatCodingStandard.Variables.UnusedVariable.UnusedVariable'] = true,
  ['GAFCodingStandard.NamingConventions.ValidVariableName.NotCamelCaps'] = true,
  ['GAFCodingStandard.NamingConventions.ValidVariableName.MemberVarNotCamelCaps'] = true,
  ['GAFCodingStandard.NamingConventions.ValidVariableName.StringVarNotCamelCaps'] = true,
  ['Drupal.NamingConventions.ValidFunctionName.InvalidName'] = true,
  ['Drupal.NamingConventions.ValidFunctionName.ScopeNotCamelCaps'] = true,
  ['Drupal.NamingConventions.ValidClassName.NoUnderscores'] = true,
  ['Generic.PHP.DeprecatedFunctions.Deprecated'] = true,
  ['PHPCompatibility.FunctionUse.ArgumentFunctionsReportCurrentValue.NeedsInspection'] = true,
  ['Generic.CodeAnalysis.UselessOverridingMethod.Found'] = true,
  -- .arclint "phpcs-src2" linter
  ['SlevomatCodingStandard.Complexity.Cognitive.ComplexityTooHigh'] = true,
}

local function demote_gaf_phpcs(diagnostics, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client or client.root_dir ~= gaf_root then
    return
  end
  for _, d in ipairs(diagnostics or {}) do
    if d.source == 'phpcs' and gaf_phpcs_advice[d.code] then
      d.severity = vim.lsp.protocol.DiagnosticSeverity.Hint
    end
  end
end

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
  -- phpantom serves pull diagnostics when the client supports them and falls
  -- back to push, so wrap both paths
  handlers = {
    ['textDocument/diagnostic'] = function(err, result, ctx)
      if result then
        demote_gaf_phpcs(result.items, ctx)
      end
      return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
    end,
    ['textDocument/publishDiagnostics'] = function(err, result, ctx)
      if result then
        demote_gaf_phpcs(result.diagnostics, ctx)
      end
      return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
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

-- root_markers is exported so a later lsp/eslint.lua on the runtimepath can reuse
-- this list when it overrides root_dir. Unused by nvim itself while root_dir is set.
local root_markers = {
  '.eslintrc', '.eslintrc.js', '.eslintrc.cjs',
  '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
  'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
  'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
  'package.json',
}

return {
  root_markers = root_markers,
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, root_markers)
    if root then on_dir(root) end
  end,
}

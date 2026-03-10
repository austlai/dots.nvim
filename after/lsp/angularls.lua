-- ~/.config/nvim/lsp/angularls.lua
-- Enable with `vim.lsp.enable('angularls')` in your init.lua
--
-- Requires @angular/language-server and typescript installed either:
--   locally:  npm install @angular/language-server typescript
--   globally: npm install -g @angular/language-server typescript

return {
  filetypes = { 'typescript', 'html', 'htmlangular' },
  root_markers = { 'angular.json', 'project.json' },
  on_new_config = function(config, root_dir)
    local server = root_dir .. '/node_modules/@angular/language-server/index.js'
    local tsdk   = root_dir .. '/node_modules/typescript/lib'

    -- fall back to global installs
    if not vim.uv.fs_stat(server) then
      local global_root = vim.fn.trim(vim.fn.system('npm root -g'))
      server = global_root .. '/@angular/language-server/index.js'
      tsdk   = global_root .. '/typescript/lib'
    end

    config.cmd = {
      'node', server,
      '--stdio',
      '--tsProbeLocations', root_dir,
      '--ngProbeLocations', root_dir,
      '--tsdk', tsdk,
    }
  end,
}

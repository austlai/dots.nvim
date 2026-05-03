return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if string.match(fname, "fl%-gaf") then
      if string.match(fname, "api%-e2e") then
        on_dir('/home/alai/freelancer-dev/fl-gaf/api-e2e')
      else
        on_dir('/home/alai/freelancer-dev/fl-gaf/webapp')
      end
    else
      local root = vim.fs.root(bufnr, {
        '.eslintrc', '.eslintrc.js', '.eslintrc.cjs',
        '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
        'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
        'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
        'package.json',
      })
      if root then on_dir(root) end
    end
  end,
}

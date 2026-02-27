return {
  root_dir = function(bufnr, on_dir)
    -- Exclude deno projects
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
      return
    end

    -- Find workspace root via lock files
    local workspace = vim.fs.root(bufnr, {
      'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock',
    })

    -- Find the nearest tsconfig (package-level)
    local tsconfig = vim.fs.root(bufnr, { 'tsconfig.json', 'jsconfig.json' })

    -- If a package-level tsconfig exists below the workspace root, use it.
    -- This prevents the workspace root tsconfig (which has no include/files) from
    -- being loaded as a project, which would cause TypeScript to scan all files.
    if tsconfig and workspace and tsconfig ~= workspace then
      on_dir(tsconfig)
      return
    end

    on_dir(workspace or vim.fs.root(bufnr, { '.git' }) or vim.fn.getcwd())
  end,
  single_file_support = false,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        enableProjectDiagnostics = false,
      },
    },
  },
}

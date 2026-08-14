-- Workspace root resolution for the PHP language servers.
--
-- Every composer package under vendor/ ships its own composer.json, so the
-- default root_markers walk stops at the first vendor package whenever you jump
-- into third-party code: `gd` into fl-gaf/vendor/awright/gaf-thrift/src/... and
-- the server roots at gaf-thrift instead of at fl-gaf. It then indexes that one
-- package in isolation, so completion and references in vendor buffers see
-- almost nothing -- and it is why phpactor's psalm provider crashed there,
-- since %project_root%/vendor/bin/psalm does not exist inside a vendor package.
--
-- Resolve from above the outermost vendor/ segment instead, so a vendor buffer
-- lands on the same root as the project that pulled it in.
local M = {}

--- Build a `root_dir` function that skips vendor/ directories.
--- Markers are read from the server's own `root_markers` at call time, so this
--- keeps whatever priority order the (possibly updated) upstream config sets.
--- @param name string server name as registered with `vim.lsp.config`
--- @return fun(bufnr: integer, on_dir: fun(root_dir?: string))
function M.resolver(name)
  return function(bufnr, on_dir)
    local markers = vim.lsp.config[name] and vim.lsp.config[name].root_markers
      or { '.git', 'composer.json' }

    -- non-greedy, so this stops at the OUTERMOST vendor/ and nested vendor
    -- trees (vendor/a/vendor/b) collapse to the real project as well
    local outer = vim.api.nvim_buf_get_name(bufnr):match('^(.-)/vendor/')
    if outer and outer ~= '' then
      local root = vim.fs.root(outer, markers)
      if root then
        return on_dir(root)
      end
      -- Nothing above vendor/ -- e.g. a package checked out at some .../vendor/
      -- path in its own right. Fall through to the default resolution rather
      -- than refusing to start.
    end

    on_dir(vim.fs.root(bufnr, markers))
  end
end

return M

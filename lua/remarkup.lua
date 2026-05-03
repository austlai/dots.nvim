-- Remarkup: Phabricator's markdown dialect. Uses tree-sitter-markdown plus
-- a decoration-provider overlay for Phabricator-specific syntax the markdown
-- parser doesn't understand (== headers, //italic//, {F123}, D456 refs, etc).

local M = {}

local ns = vim.api.nvim_create_namespace("remarkup_overlay")

local function mark(bufnr, row, col_start, col_end, group)
  if col_start < 0 or col_end <= col_start then return end
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, col_start, {
    end_col = col_end,
    hl_group = group,
    priority = 200, -- override tree-sitter's default 100
    hl_mode = "combine",
    ephemeral = true,
  })
end

-- Scan `line` for a delimiter pair (both `delim`) wrapping content matching
-- `body_pat` (a Lua pattern char class, e.g. "[^/]"). Applies `body_hl` to
-- the inner text and marker highlight to the delimiters.
local function scan_delimited(bufnr, row, line, delim, body_pat, body_hl)
  local dlen = #delim
  local i = 1
  while true do
    local s = line:find(delim, i, true)
    if not s then return end
    local content_end = line:find(delim, s + dlen, true)
    if not content_end then return end
    local content = line:sub(s + dlen, content_end - 1)
    if #content == 0 or content:match("^" .. body_pat .. "+$") then
      mark(bufnr, row, s - 1, s - 1 + dlen, "@punctuation.special.remarkup")
      mark(bufnr, row, s - 1 + dlen, content_end - 1, body_hl)
      mark(bufnr, row, content_end - 1, content_end - 1 + dlen, "@punctuation.special.remarkup")
      i = content_end + dlen
    else
      i = s + 1
    end
  end
end

local function scan_pattern(bufnr, row, line, pat, group)
  local i = 1
  while true do
    local s, e = line:find(pat, i)
    if not s then return end
    mark(bufnr, row, s - 1, e, group)
    i = e + 1
  end
end

local function scan_header(bufnr, row, line)
  local marker = line:match("^(=+) ")
  if not marker then return true end
  local level = math.min(#marker, 6)
  mark(bufnr, row, 0, #line, "@markup.heading." .. level .. ".remarkup")
  mark(bufnr, row, 0, #marker, "@punctuation.special.remarkup")
  return false -- skip inline scanning: headers are one styled span
end

local function highlight_line(bufnr, row)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  if not line or line == "" then return end

  if scan_header(bufnr, row, line) == false then return end

  scan_delimited(bufnr, row, line, "##", "[^#]", "@markup.raw.remarkup")
  scan_delimited(bufnr, row, line, "__", "[^_]", "@markup.underline.remarkup")
  -- //italic// — skip if preceded by ':' (URL scheme)
  do
    local dlen = 2
    local i = 1
    while true do
      local s = line:find("//", i, true)
      if not s then break end
      local prev = s > 1 and line:sub(s - 1, s - 1) or ""
      if prev == ":" then
        i = s + dlen
      else
        local ce = line:find("//", s + dlen, true)
        if not ce then break end
        local content = line:sub(s + dlen, ce - 1)
        if #content > 0 and not content:find("/") then
          mark(bufnr, row, s - 1, s - 1 + dlen, "@punctuation.special.remarkup")
          mark(bufnr, row, s - 1 + dlen, ce - 1, "@markup.italic.remarkup")
          mark(bufnr, row, ce - 1, ce - 1 + dlen, "@punctuation.special.remarkup")
          i = ce + dlen
        else
          i = s + 1
        end
      end
    end
  end

  -- {F123}, {F123, size=full}, {key F1}, {nav Foo}, {icon bug}, {meme ...}
  scan_pattern(bufnr, row, line, "{[FMVPTQB]%d+[^}]*}", "@markup.link.remarkup")
  scan_pattern(bufnr, row, line, "{key [^}]+}", "@markup.link.remarkup")
  scan_pattern(bufnr, row, line, "{nav [^}]+}", "@markup.link.remarkup")
  scan_pattern(bufnr, row, line, "{icon [^}]+}", "@markup.link.remarkup")
  scan_pattern(bufnr, row, line, "{meme[^}]*}", "@markup.link.remarkup")

  -- @mention, #project with word-boundary before, or at line start
  scan_pattern(bufnr, row, line, "%f[%S]@[%w_%.%-]+", "@markup.link.remarkup")
  scan_pattern(bufnr, row, line, "%f[%S]#[%w_%-]+", "@markup.link.remarkup")
  do
    local tag = line:match("^(@[%w_%.%-]+)")
    if tag then mark(bufnr, row, 0, #tag, "@markup.link.remarkup") end
    tag = line:match("^(#[%w_%-]+)")
    if tag then mark(bufnr, row, 0, #tag, "@markup.link.remarkup") end
  end

  -- Object refs: D123, T456, P789, M123, Q123, F123, V123, B123 with word boundaries.
  do
    local i = 1
    while true do
      local s, e, _ref = line:find("()([TDPMQFVB]%d+)()", i)
      if not s then break end
      local before_ok = (s == 1) or not line:sub(s - 1, s - 1):match("[%w_]")
      local ref_end = e - 1
      local after_ok = (ref_end == #line) or not line:sub(ref_end + 1, ref_end + 1):match("[%w_]")
      if before_ok and after_ok then
        mark(bufnr, row, s - 1, ref_end, "@markup.link.remarkup")
      end
      i = s + 1
    end
  end

  -- NOTE:/WARNING:/IMPORTANT: callouts at start of line
  do
    local kw = line:match("^(NOTE):%s*")
      or line:match("^(WARNING):%s*")
      or line:match("^(IMPORTANT):%s*")
    if kw then
      mark(bufnr, row, 0, #kw + 1, "@keyword.remarkup")
    end
  end
end

local function set_default_links()
  local links = {
    ["@markup.heading.1.remarkup"] = "@markup.heading.1",
    ["@markup.heading.2.remarkup"] = "@markup.heading.2",
    ["@markup.heading.3.remarkup"] = "@markup.heading.3",
    ["@markup.heading.4.remarkup"] = "@markup.heading.4",
    ["@markup.heading.5.remarkup"] = "@markup.heading.5",
    ["@markup.heading.6.remarkup"] = "@markup.heading.6",
    ["@markup.italic.remarkup"] = "@markup.italic",
    ["@markup.raw.remarkup"] = "@markup.raw",
    ["@markup.underline.remarkup"] = "Underlined",
    ["@markup.link.remarkup"] = "@markup.link",
    ["@punctuation.special.remarkup"] = "@punctuation.special",
    ["@keyword.remarkup"] = "@keyword",
  }
  for from, to in pairs(links) do
    vim.api.nvim_set_hl(0, from, { link = to, default = true })
  end
end

function M.enable(bufnr)
  bufnr = bufnr or 0
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  vim.b[bufnr].remarkup_overlay = true
end

function M.disable(bufnr)
  bufnr = bufnr or 0
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  vim.b[bufnr].remarkup_overlay = false
end

function M.setup()
  vim.filetype.add({
    extension = {
      remarkup = "remarkup",
    },
    pattern = {
      -- Phabricator-style filenames: D123.md, T456.md, P789.md
      [".*/[DTPMQVB]%d+%.md"] = "remarkup",
      -- Rendered test-plan outputs under plans/<name>/*.md
      [".*/test%-plans/plans/[^/]+/.+%.md"] = "remarkup",
      -- ETA-templated markdown: render with the markdown parser.
      [".*%.md%.eta"] = "markdown",
    },
  })

  -- Remarkup borrows tree-sitter-markdown.
  vim.treesitter.language.register("markdown", "remarkup")
  vim.treesitter.language.register("markdown_inline", "remarkup_inline")

  set_default_links()

  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, bufnr)
      return vim.b[bufnr].remarkup_overlay == true
    end,
    on_line = function(_, _, bufnr, row)
      highlight_line(bufnr, row)
    end,
  })

  local group = vim.api.nvim_create_augroup("remarkup", { clear = true })

  -- Overlay applies to both filetypes.
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "markdown", "remarkup" },
    callback = function(ev)
      M.enable(ev.buf)
    end,
  })

  -- Remarkup buffers need their own tree-sitter start + prose defaults
  -- (plugin/30-treesitter.lua only handles the canonical markdown filetype).
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "remarkup",
    callback = function(ev)
      local ok, err = pcall(vim.treesitter.start, ev.buf, "markdown")
      if not ok then
        vim.notify("remarkup: tree-sitter start failed: " .. tostring(err), vim.log.levels.WARN)
      end
      vim.bo[ev.buf].commentstring = "<!-- %s -->"
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.breakindent = true
      vim.opt_local.conceallevel = 0
    end,
  })
end

return M

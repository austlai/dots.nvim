; Lives in queries/ not after/queries/: without `; extends`, the first file in
; runtimepath order is the base, and ~/.config/nvim precedes the nvim-treesitter
; copy under ~/.local/share/nvim/site. Replaces the default: drop the html injection
; for erb content. Every .erb in my repos is a config/yaml/shell template, not
; html, and the html tree claimed the `<%` position at content boundaries,
; breaking matchup's tag jump.
((code) @injection.content
  (#set! injection.language "ruby")
  (#set! injection.combined))

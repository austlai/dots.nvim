; Pairs <% ... %> so % jumps between erb tag delimiters. Its presence also
; enables matchup's treesitter engine for eruby, so Ruby keywords inside the
; tags (if/else/end, do/end) match via the injected ruby tree instead of the
; regex fallback, which was fooled by Go-template `{{ end }}` text.
;
; ponytail: % from `<%` lands on the tag's `%>`, but % from a `%>` that directly
; follows ruby code does nothing: matchup puts the cursor on the token's first
; char before querying, and LanguageTree:language_for_range treats the code
; node's end as inclusive, so that position is answered by the ruby tree.
; Upgrade path: fix upstream in nvim's Range.contains or matchup's get_matches.
(directive
  ["<%" "<%-" "<%_"] @open.erb
  ["%>" "-%>" "_%>"] @close.erb) @scope.erb

(output_directive
  "<%=" @open.erb
  ["%>" "-%>" "_%>"] @close.erb) @scope.erb

(comment_directive
  "<%#" @open.erb
  ["%>" "-%>" "_%>"] @close.erb) @scope.erb

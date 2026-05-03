; extends

; Phabricator code fences use info strings like `lang=bash,name=Curl Request`.
; Extract the real language (everything after `lang=` up to the first comma)
; so tree-sitter injects proper syntax highlighting into the code body.

((fenced_code_block
  (info_string (language) @injection.language)
  (code_fence_content) @injection.content)
  (#gsub! @injection.language "^lang=([^,]+).*$" "%1")
  (#gsub! @injection.language ",.*$" ""))

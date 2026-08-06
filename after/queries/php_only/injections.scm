; extends

; SQL in heredocs/nowdocs whose tag doesn't name the language (gaf's <<<'EOD'
; blocks). Tags that DO name a language (<<<'SQL', <<<'JSON', ...) are already
; handled by the stock query, which reads the closing tag. Detection: the body
; opens with a SQL statement keyword. Lua patterns have no alternation, hence
; one pattern per keyword.

((nowdoc (nowdoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[sS][eE][lL][eE][cC][tT]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((nowdoc (nowdoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[iI][nN][sS][eE][rR][tT]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((nowdoc (nowdoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[uU][pP][dD][aA][tT][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((nowdoc (nowdoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[dD][eE][lL][eE][tT][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((nowdoc (nowdoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[rR][eE][pP][lL][aA][cC][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((heredoc (heredoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[sS][eE][lL][eE][cC][tT]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((heredoc (heredoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[iI][nN][sS][eE][rR][tT]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((heredoc (heredoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[uU][pP][dD][aA][tT][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((heredoc (heredoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[dD][eE][lL][eE][tT][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

((heredoc (heredoc_body) @injection.content)
  (#lua-match? @injection.content "^%s*[rR][eE][pP][lL][aA][cC][eE]%f[%W]")
  (#set! injection.language "sql")
  (#set! injection.include-children))

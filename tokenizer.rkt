#lang racket

(require brag/support)

(provide make-tokenizer)

(define (make-tokenizer port)
  (define (next-token)
    (define rjson-lexer
      (lexer
        [(eof) eof]
        [(from/to "//" "\n") (next-token)]
        [(from/to "|" "|")
         (token 'SEXP-TOK (trim-ends "|" lexeme "|"))]
        [any-char (token 'CHAR-TOK lexeme)]))
    (rjson-lexer port))
  next-token)


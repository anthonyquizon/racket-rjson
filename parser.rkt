#lang brag

rjson-program: (rjson-char | rjson-sexp)*
rjson-char : CHAR-TOK
rjson-sexp : SEXP-TOK


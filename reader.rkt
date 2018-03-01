#lang racket

(require "tokenizer.rkt" 
         "parser.rkt")

(provide read-syntax)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module rjson-module rjson/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))

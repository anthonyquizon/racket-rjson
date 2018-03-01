#lang racket 

(require json)

(provide (rename-out [js-module-begin #%module-begin])
         #%datum
         rjson-char
         rjson-program
         rjson-sexp)

(define-for-syntax (blank? str)
  (for/and ([c (in-string str)])
    (char-blank? c)))

(define-for-syntax (datum? x) (or (list? x) (symbol? x)))

(define-for-syntax (string->datum str)
  (unless (blank? str)
    (let ([result (read (open-input-string (format "(~a)" str)))])
      (if (= (length result) 1)
          (car result)
          result))))

(define-for-syntax (format-datum datum-template . args)
  (unless (datum? datum-template)
    (raise-argument-error 'format-datums "datum?" datum-template))
  (string->datum (apply format (format "~a" datum-template)
                        (map (λ (arg) (if (syntax? arg)
                                          (syntax->datum arg)
                                          arg)) args))))

(define-syntax-rule (js-module-begin PARSE-TREE)
  (#%module-begin
    (define result-string PARSE-TREE)
    (define validated-jsexpr (string->jsexpr result-string))
    (display result-string)))

(define-syntax-rule (rjson-char CHAR-TOK-VALUE)
  CHAR-TOK-VALUE)

(define-syntax (rjson-program stx)
  (syntax-case stx ()
    [(_ SEXP-OR-JSON-STR ...)
     #'(string-trim (string-append SEXP-OR-JSON-STR ...))]))

(define-syntax (rjson-sexp stx)
  (syntax-case stx ()
    [(_ SEXP-STR)
     (with-syntax 
       ([SEXP-DATUM (format-datum '~a #'SEXP-STR)])
       #'(jsexpr->string SEXP-DATUM))]))


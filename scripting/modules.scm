#!/usr/bin/env sh
exec guile -l fact.scm -e '(@ (my-module) main)' -s "$0" "$@"
!#

;; Explanation:
;; -e (my-module)
;; If run as a script run the `my-module` module's `main`.
;; (Use `@@` to reference not exported procedures.)
;; -s
;; Run the script.

(define-module (my-module)
  #:export (main))

;; Create a module named `fac`.
;; Export the `main` procedure as part of `fac`.

(define (n-choose-k n k)
  (/ (fact n)
     (* (fact k)
        (fact (- n k)))))

(define (main args)
  (let ((n (string->number (cadr args)))
        (k (string->number (caddr args))))
    (display (n-choose-k n k))
    (newline)))

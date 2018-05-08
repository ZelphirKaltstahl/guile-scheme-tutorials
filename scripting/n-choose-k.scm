#!/usr/local/bin/guile \
-l fact.scm -e main -s
!#

;; Explanation:
;; -l specifies which scripts to load first
;; -e specifies the procedure to run
;; -s specifies to run this as a script

(define (n-choose-k n k)
  (/ (fact n)
     (* (fact k)
        (fact (- n k)))))

(define (main args)
  (let ((n (string->number (cadr args)))
        (k (string->number (caddr args))))
    (display (n-choose-k n k))
    (newline)))

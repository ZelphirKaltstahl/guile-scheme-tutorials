#!/usr/local/bin/guile \
-e main -s
!#

;; How to run this program?
;; Example:
;; guile -e main -s factorial-script.scm 50
;; Explanation:
;; -e specifies the procedure to run
;; -s specifies to run this as a script
;; 50 is the number we take as input to the script

(define (fact n)
  (if (zero? n) 1
      (* n (fact (- n 1)))))

(define (main args)
  (display (fact (string->number (cadr args))))
  (newline))

#!/usr/local/bin/guile \
-l fact -e (@ (fac) main) -s
!#

;; Explanation:
;; -e (@ (fac) main)
;; If run as a script run the `fac` module's `main`.
;; (Use `@@` to reference not exported procedures.)
;; -s
;; Run the script.

(define-module (fac)
  #:export (main))

;; Create a module named `fac`.
;; Export the `main` procedure as part of `fac`.

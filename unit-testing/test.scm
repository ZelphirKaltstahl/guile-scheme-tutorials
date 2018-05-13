(define (assert-test? a b test?)
  (unless (test? a b)
    (throw 'assertion-failure
           #f
           "assertion failure"
           a b
           #f)))

(define (assert-equal? a b)
  (assert-test? a b equal?))

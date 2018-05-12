(use-modules (srfi srfi-1)
             (ice-9 receive))

(receive (a b)
    (partition (lambda (num) (= (remainder num 2) 0)) '(1 2 3 4 5))
  (display (list a b)))

(use-modules (ice-9 threads))

(define (busy-work limit)
  (if (> limit 0)
      (begin (sqrt (+ (expt limit limit) 1))
             (busy-work (- limit 1)))
      'done))

(define (displayln something)
  (display something)
  (newline))

(let ((limit 1000))
  (display
   ;; to use multiple values one can use `call-with-values`.
   (call-with-values
       (lambda () (parallel (busy-work 1000)
                            (busy-work 1000)))
     (lambda (a b) (displayln (list a b))))))


;; You can also use receive to create the bindings.
(use-modules (ice-9 receive))
(let ((limit 1000))
  (display
   ;; to use multiple values one can use `receive`.
   (receive (range1 range2)
       (parallel (busy-work 1000)
                 (busy-work 1000))
     (list range1 range2))))

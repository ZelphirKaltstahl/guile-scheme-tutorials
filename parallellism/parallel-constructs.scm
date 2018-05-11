(use-modules (ice-9 threads))

(define (busy-work limit)
  (+ 1 1)
  (busy-work (- limit 1)))

(parallel (busy-work 100000)
          (busy-work 100000)
          (busy-work 100000)
          (busy-work 100000))

(use-modules (srfi srfi-1)
             (ice-9 pretty-print)
             (ice-9 receive))


(define (take-up-to n xs)
  (cond [(or (zero? n) (null? xs)) '()]
        [else (cons (car xs)
                    (take-up-to (- n 1) (cdr xs)))]))
(define (drop-up-to to-drop xs)
  (cond [(or (= to-drop 0) (null? xs)) xs]
        [else (drop-up-to (- to-drop 1) (cdr xs))]))
(define (split-into-chunks-of-size-n xs n)
  (cond [(null? xs) '()]
        [else (let ([first-chunk (take-up-to n xs)]
                    [rest (drop-up-to n xs)])
                (cons first-chunk (split-into-chunks-of-size-n rest n)))]))
(define (split-into-n-chunks xs n)
  (let* ([number-of-elements (length xs)]
         [size-of-chunks (inexact->exact (ceiling (/ number-of-elements n)))])
    (split-into-chunks-of-size-n xs size-of-chunks)))

;; (define (chunkify xs n)
;;   (define (distribute-remaining-elems partitions remaining)
;;     (cond [(<= (length partitions) (length remaining))
;;            (throw 'wrong-argument
;;                   #f
;;                   (string-append
;;                    "remaining should have less elements than the partitions,"
;;                    " but has more or an equal amount of elements")
;;                   #f
;;                   #f)]
;;           [else
;;            (cond [(null? remaining) partitions]
;;                  [else
;;                   (cons (cons (car remaining)
;;                               (car partitions))
;;                         (distribute-remaining-elems (cdr partitions)
;;                                                     (cdr remaining)))])]))

;;   (let* ([len (length xs)]
;;          [start-length]
;;          [start-elems (take-up-to (remainder length n) xs)]
;;          [rest-elems (drop-up-to (remainder length n) xs)])
;;       (let ([split-rest-res (split-into-n-chunks rest-elems n)])
;;         (display "split-rest-res: ")
;;         (pretty-print split-rest-res)
;;         (newline)
;;         (distribute-remaining-elems split-rest-res start-elems))))

(define (assert-test? a b test?)
  (unless (test? a b)
    (throw 'assertion-failure
           #f
           "assertion failure: ~S and ~S with ~A"
           a b test?
           #f)))

(define (assert-equal? a b)
  (assert-test? a b equal?))

;; (assert-equal? (chunkify (iota 9) 4)
;;                '((0 1 2) (3 4) (5 6) (7 8)))
;; (assert-equal? (chunkify (iota 11) 6)
;;                '((0 1)
;;                  (2 3)
;;                  (4 5)
;;                  (6 7)
;;                  (8 9)
;;                  (10)))

(define (busy-work limit)
  (if (> limit 0)
      (begin (sqrt (+ (expt limit limit) 1))
             (busy-work (- limit 1)))
      'done))

(n-par-map (current-processor-count)
           busy-work
           (list 20000 20000))

(define (busy-work-2 lst)
  (cond [(null? lst) 'done]
        [else
         (expt (car lst) (car lst))
         (busy-work-2 (cdr lst))]))

(define (time thunk)
  (define starting-time (current-time))
  (define res (thunk))
  (define ending-time (current-time))
  (display "elapsed time: ")
  (display (- ending-time starting-time))
  (display "s")
  (newline)
  res)


(define (partition-4 numbers)
  (define (loop numbers rc0 rc1 rc2 rc3)
    (cond [(null? numbers) (list (reverse rc0)
                                 (reverse rc1)
                                 (reverse rc2)
                                 (reverse rc3))]
          [else
           (let* ([number (car numbers)]
                  [residue (remainder number 4)])
             (cond [(= residue 0) (loop (cdr numbers)
                                        (cons number rc0)
                                        rc1
                                        rc2
                                        rc3)]
                   [(= residue 1) (loop (cdr numbers)
                                        rc0
                                        (cons number rc1)
                                        rc2
                                        rc3)]
                   [(= residue 2) (loop (cdr numbers)
                                        rc0
                                        rc1
                                        (cons number rc2)
                                        rc3)]
                   [(= residue 3) (loop (cdr numbers)
                                        rc0
                                        rc1
                                        rc2
                                        (cons number rc3))]))]))
  (loop numbers '() '() '() '()))

(n-par-map (current-processor-count)
           busy-work-2
           (split-into-n-chunks (iota 30000) 4))

(time
 (lambda ()
   (n-par-map (current-processor-count)
              busy-work-2
              (split-into-n-chunks (iota 30000) 4))))

(time
 (lambda ()
   (n-par-map (current-processor-count)
              busy-work-2
              (split-into-n-chunks (iota 30000) 2))))

(time
 (lambda ()
   (n-par-map (current-processor-count)
              busy-work-2
              (receive (evens odds)
                  (partition even? (iota 30000))
                (list evens odds)))))

;; test with 2 cores
(let ([evens-and-odds (receive (evens odds)
                          (partition even? (iota 30000))
                        (list evens odds))])
  (time
   (lambda ()
     (par-map busy-work-2
              evens-and-odds))))

;; test with 4 cores
;; parallel
(let ([residue-classes (partition-4 (iota 30000))])
  (time
   (lambda ()
     (parallel (busy-work-2 (car residue-classes))
               (busy-work-2 (cadr residue-classes))
               (busy-work-2 (caddr residue-classes))
               (busy-work-2 (cadddr residue-classes))))))
(let ([residue-classes (partition-4 (iota 50000))])
  (time
   (lambda ()
     (parallel (busy-work-2 (car residue-classes))
               (busy-work-2 (cadr residue-classes))
               (busy-work-2 (caddr residue-classes))
               (busy-work-2 (cadddr residue-classes))))))

;; par-map
(let ([residue-classes (partition-4 (iota 30000))])
  (time
   (lambda ()
     (par-map busy-work-2
              residue-classes))))
;; n-par-map - max cores
(let ([residue-classes (partition-4 (iota 30000))])
  (time
   (lambda ()
     (n-par-map (current-processor-count)
                busy-work-2
                residue-classes))))
;; n-par-map - 2 cores
(let ([residue-classes (partition-4 (iota 30000))])
  (time
   (lambda ()
     (n-par-map 2
                busy-work-2
                residue-classes))))
;; n-par-map - 1 core
(let ([residue-classes (partition-4 (iota 30000))])
  (time
   (lambda ()
     (n-par-map 1
                busy-work-2
                residue-classes))))


;; test with single core to see speedup
(time
 (lambda ()
   (par-map busy-work-2
            (list (iota 30000)))))

;; hooks:
;; open, read, write, and close

(use-modules (web server))

;; General Structure:
;; (define (handler request request-body)
;;   (values response response-body))

(define (hello-world-handler request request-body)
  (values '((content-type . (text/plain)))
          "Hello World!"))

(run-server  hello-world-handler)

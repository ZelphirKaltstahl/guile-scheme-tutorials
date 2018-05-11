(use-modules (web server))
(use-modules (web request)
             (web response)
             (web uri))

;; 1. get request URI
;; 2. get URI path from URI (probably the part without domain)
;; 3. split URI path into its string parts
(define (request-path-components request)
  (split-and-decode-uri-path
   (uri-path
    (request-uri request))))

;; handler for the not found case
(define (not-found request)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define (hello-hacker-handler request body)
  (if (equal? (request-path-components request) '("hacker"))
      ;; if the request path component is only '("hacker") we respond with a greeting
      (values '((content-type . (text/plain)))
              "Hello hacker!")
      ;; else answer with "not found" to the request
      (not-found request)))

(run-server hello-hacker-handler)

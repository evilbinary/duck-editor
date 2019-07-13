;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(module scheme.complete (id-completions show-complete find-previous-word)
(import duck.snippets)
(define-syntax assert*
  (syntax-rules ()
    [(_ expr ...)
     (begin (assert expr) ...)]))

(define-syntax on-error
  (syntax-rules ()
    [(on-error e0 e1 e2 ...)
     (guard (c [#t e0]) e1 e2 ...)]))
     
  (define common-identifiers
    (make-parameter
        '(append apply call/cc call-with-values define display display-string
        define-syntax define-record null? quote quotient reverse read-char
        substring string-ref string-length string? string=? string-set!
        syntax-case syntax-rules unless vector-ref vector-length vector?
        vector-set! vector)
        (lambda (x)
        (unless (and (list? x) (andmap symbol? x))
            ($oops 'common-identifiers "~s is not a list of symbols" x))
        x)))
    (define entry-col string-length)
    (define (id-completions entry)
        (define (idstring<? prefix)
        (let ([common (common-identifiers)]
                [scheme-syms (environment-symbols (scheme-environment))])
            (lambda (s1 s2)
            (let ([x1 (string->symbol (string-append prefix s1))]
                    [x2 (string->symbol (string-append prefix s2))])
                ; prefer common
                (let ([m1 (memq x1 common)] [m2 (memq x2 common)])
                (if m1
                    (or (not m2) (< (length m2) (length m1)))
                    (and (not m2)
                        ; prefer user-defined
                        (let ([u1 (not (memq x1 scheme-syms))]
                                [u2 (not (memq x2 scheme-syms))])
                            (if u1
                                (or (not u2) (string<? s1 s2))
                                (and (not u2) (string<? s1 s2)))))))))))
        (define (completion str1 str2)
        (let ([n1 (string-length str1)] [n2 (string-length str2)])
            (and (fx>= n2 n1)
                (string=? (substring str2 0 n1) str1)
                (substring str2 n1 n2))))
        (define (fn-completions prefix)
        (values prefix
            (sort string<?
            (fold-left
                (let ([last (path-last prefix)])
                (lambda (suffix* s)
                    (cond
                    [(completion last s) =>
                    (lambda (suffix) 
                        (cons (if (file-directory? (string-append prefix suffix))
                                (string-append suffix (string (directory-separator)))
                                suffix)
                        suffix*))]
                    [else suffix*])))
                '()
                (on-error '()
                (directory-list
                    (let ([dir (path-parent prefix)])
                    (if (string=? dir "") "." dir))))))))
        (let loop ([c 0])
        (if (fx>= c (entry-col entry))
            (values #f '())
            (let ([s (let ([s entry])
                        (substring s c (string-length s)))])
                ((on-error
                (lambda ()
                    (if (and (fx> (string-length s) 0) (char=? (string-ref s 0) #\"))
                        (fn-completions (substring s 1 (string-length s)))
                        (loop (fx+ c 1))))
                (let-values ([(type value start end) (read-token (open-input-string s))])
                    (lambda ()
                    (cond
                        [(and (fx= (fx+ c end) (entry-col entry))
                            (eq? type 'atomic)
                            (symbol? value))
                        (let ([prefix (symbol->string value)])
                            (values prefix
                            (sort (idstring<? prefix)
                                (fold-left (lambda (suffix* x)
                                            (cond
                                            [(completion prefix (symbol->string x)) =>
                                                (lambda (suffix) (cons suffix suffix*))]
                                            [else suffix*]))
                                '() (environment-symbols (interaction-environment))))))]
                        [(and (fx= (fx+ c end -1) (entry-col entry))
                            (eq? type 'atomic)
                            (string? value))
                        (fn-completions value)]
                        [else (loop (fx+ c end))])))))))))


  (define (show-complete keyword)
    (let-values ([(prefix suffix*) (id-completions keyword)])
        (if prefix
            (begin
            ; (printf "prefix ~a ~a == ~a\n" prefix (length suffix*) 
            ;     (length (map (lambda (suffix) (string-append prefix suffix)) suffix*) ))
            (show-snippets (map (lambda (suffix) (string-append prefix suffix)) suffix*) )
            ))))

    (define separator?
      (lambda (c)
        (memq c '(#\space #\; #\( #\) #\[ #\] #\" #\' #\`))))


    (define find-previous-word
    (case-lambda
     [(entry cols)
      (let ([lns entry])
        (let loop ([col cols])
            (cond
                [(or (fx= col 0)
                    (separator? (string-ref entry (fx1- col))))
                (begin 
                    ;;(printf "==>~a\n" (substring entry col cols))
                    (substring entry col cols))]
                [else (loop (fx1- col))])))
      ]
     [(entry)
        (find-previous-word entry (string-length entry))
     ]    
     ))
      


)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(define all-key-func (make-hashtable equal-hash equal?))
(define all-keys-status (make-hashtable equal-hash equal?) )
(define default-key-map (make-hashtable equal-hash equal?))
(define default-key-maps 
    (list
        '(ctl #x0002)
        '(shift #x0001)
        '(alt #x0004)
        '(super #x0008)
        '(caps-lock #x0010)
        '(num-lock #x0020)
        '(a 65)
        '(b 66)
        '(c 67)
        '(d 68)
        '(v 86)
        '(x 88)
    ))

(define (set-default-key-map key val)
    (hashtable-set! default-key-map key val))

(define (get-default-key-map key)
    (hashtable-ref default-key-map key '()))

(define (init-key-map)
    (let loop ((l default-key-maps))
        (if (pair? l)
        (begin 
            ;;(printf "~a ~a ~a\n" (car l) (caar l)  (cadar l))
            (set-default-key-map (caar l) (cadar l))
            (loop (cdr l))
        ))))

(define (is-key-press key)
    (hashtable-ref all-keys-status (get-default-key-map key) '()))

(define (is-multi-key-press keys)
    (= (length keys) 
        (length (filter (lambda (x )
                    (let ((ret (is-key-press x) ))
                    (if (null? ret)
                        #f
                        (> ret 0)
                     )))
                keys))))

(define (set-key-map keys fun)
    (hashtable-set! all-key-func keys fun))

(define (get-key-map keys)
    (hashtable-ref all-key-func keys '()))


(define (process-key-map keys)
    (if (is-multi-key-press keys )
        (let ((fun (get-key-map keys )))
            (fun))
    ))

(define (process-keys-map)
    (let loop ((k (vector->list (hashtable-keys all-key-func))))
        (if (pair? k)
            (begin 
                (process-key-map (car k))
                (loop (cdr k))
            )
        )
    ))

(register 'keys.edit (lambda (duck)
    (init-key-map)
    (let ((editor (get-var duck 'editor))
          (s0 (get-var duck 'tree.scroll ))
          (s1 (get-var duck 'editor.scroll ))
          (syn (get-var duck 'syntax )))
       (set-key-map '(ctl a) (lambda()
            (printf "hook key ctl a\n")
            (printf "line count===>~a\n" (widget-get-attrs editor 'line-count ))
            (printf "last-row-count=>~a\n" (widget-get-attrs editor 'last-row-count) )
            (widget-set-attrs editor 'selection 
                (list 0 0 
                    (widget-get-attrs editor 'line-count ) 
                    (widget-get-attrs editor 'last-row-count)))
       ))
       (set-key-map '(ctl c) (lambda()
            (printf "hook key ctl c\n")
            ;;(printf "get copy ~a\n" (widget-get-attrs editor 'selection) )
            (set-var 'editor.copy (widget-get-attrs editor 'selection))
       ))

       (widget-add-event editor (lambda (w p type data)
        (if (= type %event-key)
            (let ((action (vector-ref data 2))
                  (key (vector-ref data 0))
                  (scancode (vector-ref data 1))
                  (mods (vector-ref data 3)))
                ;;(printf "get editor event ~a action=~a key=~a mods=~a\n" type action key mods )
                ;;(printf "(get-key-map key)=>~a\n" (get-key-map key))
                (hashtable-set! all-keys-status key action)
                (hashtable-set! all-keys-status mods action)
                ;;(printf "is key press ~a\n" (is-key-press 'a ))
                ;;(printf "is-multi-key-press ~a\n" (is-multi-key-press '(ctl a) ))
                (process-keys-map)
                
            ))
       ))
    )))
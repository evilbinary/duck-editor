;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))
(import duck.snippets)
(import scheme.complete)

(register 'snippets.scheme (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (syn (get-var duck 'syntax ))
          (s1 (get-var duck 'editor.scroll ))
          )
        (if (null? (get-var 'editor.snippets))
            (let ((snippets (pop-snippets))) 
                (widget-set-layout s1 free-layout)
                (set-var 'editor.snippets snippets)
                (widget-set-attr snippets %visible #f)
                (widget-add s1 snippets)
            ))
        (widget-add-event s1 
            (lambda (w p type d)
            (if (= type %event-key)
				(let ((xy (widget-get-attrs editor 'cursor-xy ) ))
                    '()
                    (set-snippets-pos (list-ref xy 0) (+ 30.0 (list-ref xy 1)))
                    
                    (if (equal? '/  (get-default-key-map (vector-ref d 0)))
                        (begin 
                            (printf "current text=~a\n" (find-previous-word (widget-get-attrs editor 'current-line-text)))
                            (show-complete (find-previous-word (widget-get-attrs editor 'current-line-text)))
                        ))
                    ;;(printf "xy=~a\n" xy) 
            ))))
        (register-var-change 'editor.snippets.text 
            (lambda (name val)
                (printf "select ~a\n" val)
            )
        )

        
        '()
        ;;(show-snippets-pos 100.0 140.0)

    )))



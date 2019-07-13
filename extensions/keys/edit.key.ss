;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))
(import duck.keys)

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
            ;(printf "current line text ~a\n" (widget-get-attrs editor 'current-line-text))
       ))
       (set-key-map '(cmd c) (lambda()
            (set-var 'editor.copy (widget-get-attrs editor 'selection))
       ))
       (set-key-map '(cmd a) (lambda()
            (widget-set-attrs editor 'selection 
                (list 0 0 
                    (widget-get-attrs editor 'line-count ) 
                    (widget-get-attrs editor 'last-row-count)))
       ))

       (set-key-map '(cmd v) (lambda()
            (printf "insert-text-at\n")
            (widget-set-attrs editor 'insert-text-at (list 0 0 "hahah"))
        ))

       (widget-add-event editor (lambda (w p type data)
        (if (= type %event-key)
            (let ((action (vector-ref data 2))
                  (key (vector-ref data 0))
                  (scancode (vector-ref data 1))
                  (mods (vector-ref data 3)))
                (printf "get editor event ~a action=~a key=~a mods=~a\n" type action key mods )
                (set-key-status key action)
                (process-keys-map)
            ))
       ))
    )))
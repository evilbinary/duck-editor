;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(register 'theme.dracula (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (s0 (get-var duck 'tree.scroll ))
          (s1 (get-var duck 'editor.scroll ))
          (header (get-var duck 'menu ))
          (syn (get-var duck 'syntax )))
        ;;ligth theme
        (add-color syn 'identify #xffffb86c)
        (add-color syn 'number #xffbd93f9)
        (add-color syn 'comment #xff6272a4)
        (add-color syn 'string #xfff1fa8c)
        (add-color syn 'keyword #xffff79c6)
        (add-color syn 'normal #xff333333)
        (add-color syn 'operator #xff333333)        
        (register-var-change 
          'tree 
          (lambda (name val)
            (widget-set-attrs val 'color #xff333333)
          ))
        ;;(widget-set-attr header %visible #f)

        (widget-set-attrs header 'color #xff333333)
        (widget-set-attrs header 'background #xfafafa)
        
        (widget-set-attrs editor 'select-color #xffb5d5fc)
        (widget-set-attrs editor 'cursor-color #xff333333)
        (widget-set-attrs editor 'color #xff333333)
        (widget-set-attrs editor 'show-no 1)
        (widget-set-attrs editor 'lineno-color #xff6272a4)

        (widget-set-attrs s0 'background #xfafafa)
        (widget-set-attrs s1 'background #xffffff)
        (widget-set-attrs s0 'show-scroll #f)
        (widget-set-attrs editor 'font "Roboto-Regular.ttf")
        (widget-set-attrs editor 'font-size 22.0)
        (widget-set-attrs editor 'font-line-height 1.2)
    )))
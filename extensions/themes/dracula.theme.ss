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
          (syn (get-var duck 'syntax )))
        ;;dracula theme
        (add-color syn 'identify #xffffb86c)
        (add-color syn 'number #xffbd93f9)
        (add-color syn 'comment #xff6272a4)
        (add-color syn 'string #xfff1fa8c)
        (add-color syn 'keyword #xffff79c6)
        (add-color syn 'normal #xfff8f8f2)
        (widget-set-attrs editor 'show-no 1)
        (widget-set-attrs editor 'lineno-color #xff6272a4)
        (widget-set-attrs editor 'select-color #xff44475a)
        (widget-set-attrs editor 'cursor-color #xfff8f8f0)
        (widget-set-attrs s0 'background #x282a36)
        (widget-set-attrs s1 'background #x282a36)
        (widget-set-attrs editor 'font "Roboto-Regular.ttf")
        (widget-set-attrs editor 'font-size 38.0)
        (widget-set-attrs editor 'font-line-height 1.2)
    )))
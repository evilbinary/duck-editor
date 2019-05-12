;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(register 'syntax.scheme (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (syn (get-var duck 'syntax )))
        ;;syntax here
        (add-keyword syn "if")
        (add-keyword syn "define")
        (add-keyword syn "import")
        (add-keyword syn "display")
        (add-keyword syn "set!")
        (add-keyword syn "def-function")
        (add-keyword syn "def-function-callback")
        (add-identify syn "=")
        
        (widget-set-attrs editor 'syntax syn)
        (widget-set-attrs editor 'syntax-on #t)
    )))
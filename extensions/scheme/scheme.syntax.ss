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
        (let loop ((keywords (environment-symbols (scheme-environment)) ))
          (if (pair? keywords)
            (begin 
              (add-keyword syn  (symbol->string (car keywords)) )
              (loop (cdr keywords)))))
        
        (add-keyword syn "if")
        (add-keyword syn "define")
        (add-keyword syn "import")
        (add-keyword syn "display")
        (add-keyword syn "set!")
        (add-keyword syn "def-function")
        (add-keyword syn "def-function-callback")
        (add-keyword syn "define-syntax")
        (add-keyword syn "begin")

        (add-identify syn "=")
        (add-identify syn "null?")
        (add-identify syn "#f")
        (add-identify syn "#t")
        (add-identify syn "'()")
        (add-keyword syn "let")
        (add-keyword syn "lambda")

        
        

        (widget-set-attrs editor 'syntax syn)
        (widget-set-attrs editor 'syntax-on #t)
    )))
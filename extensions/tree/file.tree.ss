;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))
(import duck.tree duck.file)

(register 'tree.file-manager (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (file-tree (get-var duck 'tree ))
          (s0 (get-var duck 'tree.scroll ))
          (work-dir (get-var duck 'work.dir ))
          )
        ;;here
        (init-tree-res)
        (if (null? file-tree )
            (begin 
            (set! file-tree (icon-tree 260.0 200.0  (string-append "  " (path-last work-dir) )))
            (set-var 'tree file-tree)
            (widget-set-status file-tree  %status-active)
            ))
        (if (null? work-dir)
            (make-file-tree file-tree "../")
            (make-file-tree file-tree work-dir))
        
        (register-var-change 
          'work.dir 
          (lambda (name val)
            (printf "val  ~a change ~a\n" name val)
            (reload-file-tree file-tree val)
        ))
        (widget-add s0 file-tree)
        (widget-set-padding file-tree 40.0 20.0 20.0 20.0)
        
        (if (file-exists? (path-append work-dir "duck-editor.ss"))
            (widget-set-attr editor %text (readlines (path-append work-dir "duck-editor.ss") ) ))
            
    )))
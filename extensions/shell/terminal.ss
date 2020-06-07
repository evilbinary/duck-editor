;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))
(import duck.browser duck.tree duck.file duck.menu)

(register 'shell.bar (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (file-tree (get-var duck 'tree ))
          (header (get-var duck 'menu ))
          (tree-scroll (get-var duck 'tree.scroll ))
          (work-dir (get-var duck 'work.dir ))
          )
    (printf "termial loaded\n")
    )))
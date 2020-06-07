;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import  (scheme)
	 (glfw glfw)
	 (gui graphic)
	 (gui duck)
   (gui draw)
	 (gui stb)
	 (gles gles1)
	 (gui window)
	 (cffi cffi)
	 (gui layout)
	 (gui widget)
	 (gui syntax)
	 (c c-ffi)
   (extensions extension)
	 (utils libutil) (utils macro) (utils trace))

(define window '() )
(define width 1000)
(define height 850)
;;(cffi-log #t)
(stack-trace-exception)

(define app-dir "../apps/duck-editor")

(define (init-res)
  (set-var 'app.dir app-dir)
  (set-var 'resources.dir (path-append app-dir "resources") )
  (set-var 'extensions.dir (path-append app-dir "extensions") )
)
  
(define (init-editor)
  (let ((header (pop %match-parent 30.0 ""))
    (panel (view %match-parent %match-parent))
    (s0 (scroll 200.0 %match-parent ))
    (s1 (scroll %fill-rest %match-parent ))
    (file-tree '() )
    (editor (edit %match-parent %wrap-content "" ) )
    (syn (init-syntax))
	)
    ;;reg var
    (set-var 'editor editor)
    (set-var 'syntax syn)
    (set-var 'tree file-tree)
    (set-var 'menu header)
    (set-var 'theme '() )
    (set-var 'editor.scroll s1 )
    (set-var 'tree.scroll s0 )
    
    (widget-set-padding panel 0.0 0.0 30.0 30.0)

    ;;(make-file-tree file-tree "../")
    ;;(make-file-tree file-tree "/Users/evil/dev/lisp/scheme-lib/")

    (widget-set-attrs s0 'background #x272822)
    (widget-set-attrs s1 'background #x272822)

    (if (not (null? file-tree))
      (begin 
        (widget-add s0 file-tree)
        (widget-set-padding file-tree 40.0 20.0 20.0 20.0)
      ))

    (widget-set-attr s0 %text "tree scroll")
    (widget-set-attr s1 %text "edit scroll")
    (widget-set-attr panel %text "panel")
    
    (widget-add s1 editor)

    ;;(widget-set-layout s1 frame-layout)
    (widget-add panel s0)
    (widget-add panel s1)
    (widget-add panel)
    (widget-add header)

    )
  )

(define (init-event)
  (register-var-change 
      'editor.copy 
      (lambda (name val)
        (printf "val  ~a change ~a\n" name val)
        (glfw-set-clipboard-string window val)
    ))
)

(define (load-conf)
  (if (file-exists? (path-append app-dir ".duck.ss"))
    (load (path-append app-dir ".duck.ss")))
  (if (file-exists? "~/.duck.ss")
    (load "~/.duck.ss"))
  (if (file-exists? "~/.duck")
    (load "~/.duck"))
)

(define (process-args)
  (if (> (length (command-line)) 0)
    (if (file-directory? (list-ref (command-line) 0 ))
	    (set! app-dir (list-ref (command-line) 0 ) )
      (set! app-dir (path-parent (list-ref (command-line) 0 )) )
      ))
      (printf "app.dir ~a\n" app-dir)
      (set-var 'work.dir app-dir)
  )

(define (duck-editor)
  (set! window (window-create width height "鸭子编辑器"))
  ;;(window-set-fps-pos 750.0 0.0)
  ;;(window-set-fps-pos  0.0  0.0)
  ;;(window-set-wait-mode #f)
  (window-show-fps #t)
  (process-args)
  ;;load res
  (init-res)
  ;;ui init here
  (init-editor)
  ;;init event
  (init-event)
  ;;load config
  (load-conf)
  ;;load extensitons
  (load-extensions duck-extensions)
  ;;run
  (window-loop window)
  (window-destroy window)
  )

(duck-editor)

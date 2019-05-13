;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import  (scheme)
	 (glfw glfw)
	 (gui graphic)
	 (gui duck)
	 (gui stb)
	 (gles gles1)
	 (gui window)
	 (cffi cffi)
	 (gui layout)
	 (gui widget)
	 (gui syntax)
	 (c c-ffi)
   (extensions extension)
	 (utils libutil) (utils macro) )

(define window '() )
(define width 1000)
(define height 840)
;;(cffi-log #t)

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
    (editor (edit %match-parent %match-parent "" ) )
    (about (dialog 240.0 180.0 320.0 200.0 "关于鸭子编辑器"))
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

    ;;set header
    (let ((menu-file (pop 60.0 30.0 "文件"))
      (menu-edit (pop 60.0 30.0 "编辑"))
      (menu-help (pop 60.0 30.0 "帮助"))
      (menu-search (pop 60.0 30.0 "查找"))
      (menu-open (pop 60.0 30.0 "打开"))
      (menu-save (pop 60.0 30.0 "保存"))
      (menu-quit (pop 60.0 30.0 "退出"))
      (menu-about (pop 60.0 30.0 "关于"))
	  )
      
      (widget-add header menu-file)
      (widget-add header menu-edit)
      (widget-add header menu-search)
      (widget-add header menu-help)
      ;;(widget-add header menu-empty)

      (widget-set-attrs header 'center #t)
      (widget-set-attrs header 'root #t)
      (widget-set-attrs header 'static #t)

      (widget-set-attrs menu-file 'root #t)
      (widget-set-attrs menu-edit 'root #t)
      (widget-set-attrs menu-search 'root #t)
      (widget-set-attrs menu-help 'root #t)
      
      ;;(widget-set-attrs menu-empty 'is-root #t)

      (widget-add menu-file menu-open)
      (widget-add menu-file menu-save)
      (widget-add menu-file menu-quit)
      (widget-add menu-help menu-about)

      ;;set abount
      (let ((info (edit 300.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/ 
 ;;QQ群：Lisp兴趣小组239401374 啊哈哈"))
	    (close (button 120.0 30.0 "关闭"))
	    )
	(widget-add about info)
	(widget-add about close)

	;;(widget-set-margin close 0.0 0.0 100.0 100.0)
	(widget-set-attrs info 'editable #f)
	(widget-set-events
	 close 'click
	 (lambda (w p type data)
	   (widget-set-attr about %visible #f)
	   ))
	(widget-set-events
	 menu-about 'click
	 (lambda (w p type data)
	   (printf "click abount\n")
	   (widget-set-attr about %visible #t)
	   ))
	) 
      )
    
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

    (widget-add s1 editor)

    ;;(widget-set-layout s1 frame-layout)
    (widget-add panel s0)
    (widget-add panel s1)

    (widget-set-attr s0 %text "s0")
    (widget-set-attr s1 %text "s1")
    (widget-set-attr panel %text "panel")
    (widget-add panel)
    (widget-add header)
    (widget-add about)
    (widget-set-attr about %visible #f)
    )
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
  ;;(window-show-fps #t)
  (process-args)
  ;;load res
  (init-res)
  ;;ui init here
  (init-editor)
  ;;load config
  (load-conf)
  ;;load extensitons
  (load-extensions duck-extensions)
  
  ;;run
  (window-loop window)
  (window-destroy window)
  )

(duck-editor)

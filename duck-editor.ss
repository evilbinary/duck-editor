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
	 (gui video)
	 (gui layout)
	 (gui widget)
	 (gui syntax)
	 (c c-ffi)
	 (utils libutil) (utils macro) )

(define window '() )
(define width 1000)
(define height 840)
;;(cffi-log #t)

(define (read-line . port)
  (let* ((char (apply read-char port)))
    (if (eof-object? char)
    char
    (do ((char char (apply read-char port))
         (clist '() (cons char clist)))
        ((or (eof-object? char) (char=? #\newline char))
         (list->string (reverse clist)))))))


(define (readlines2 filename)
  (call-with-input-file filename
    (lambda (p)
      (let loop ((line (read-line p))
                 (result "" ))
        (if (eof-object? line)
             (string-append result "\n")
            (loop (read-line p)
		  (string-append result line "\n")))))))

(define (readlines file)
 (let ((f (c-fopen file "rb"))
       (buf (cffi-alloc 1024))
       (buffer "")
       )
   (let loop ((len (c-fread buf 1 1024 f)))
     (if (> len 0)
	 (begin
	   '()
	   ;;(cwrite-all port buf len)
	   ;;(printf "buff ~a\n" (cffi-string buf))
	   (set! buffer (string-append buffer (cffi-string buf)))
	   (cffi-set buf 0 1024)
	   (loop (c-fread buf 1 1024 f))  )
	 (begin 
	   (c-fclose f )
	   buffer)
	 ) )))

(define file-icon -1) 
(define dir-icon -1) 
(define dir-icon-open  -1)
(define ed -1)

(define (init-res)
  (set! file-icon (load-texture "file-text.png"))
  (set! dir-icon (load-texture "folder.png"))
  (set! dir-icon-open (load-texture "folder-open.png"))
)

(define (icon-tree w h text)
  (let ((it (tree w h text))
	)
    (widget-add-draw
     it
     (lambda (w p)
       (let ((x (vector-ref w %gx))
	     (y (vector-ref w %gy)))
	 (if (null? (widget-get-attrs w 'dir))
	     (draw-image (+  -20.0 x) (+ y 6.0) 15.0 15.0 file-icon)
	     (draw-image (+ -20.0 x) (+ y 6.0) 15.0 15.0 dir-icon))
	 )
       ))
    (widget-set-padding it 15.0 20.0 20.0 20.0)
    it
    ))

(define tree-item-click
  (lambda (w p type data)
    (printf "click ~a ~a\n" type
	    (widget-get-attr w %text)
	    )
    (let ((path (widget-get-attrs w 'path)))
      (if (file-directory? (string-append path  (widget-get-attr w %text)))
	  (begin
	    (widget-set-attrs w 'dir #t)
	    (widget-set-child w '())
	    (make-file-tree w (string-append path (widget-get-attr w %text)  "/") )
	    (widget-layout-update (widget-get-root w))
	    )
	  (begin
	    ;;(printf "ed select ~a\n"  (string-append path  (widget-get-attr w %text)) )
	    (widget-set-attr ed %text (readlines2 (string-append path  (widget-get-attr w %text)) ) )
	    )
	  )
      )))

(define (make-file-tree tree path)
  (let loop ((files (directory-list path)))
    (if (pair? files)
	(let ((n (icon-tree  200.0 200.0  (car files) )))
	  (if (file-directory? (string-append path  (car files)))
	      (widget-set-attrs n 'dir #t))
	  (widget-set-attrs n 'path path)
	  (widget-set-events
	   n
	   'click
	   tree-item-click
	   )
	  (widget-add tree n) 
	  (loop (cdr files)))
	))
  )
  
(define (init-editor)
  (let ((header (pop %match-parent 30.0 ""))
	(panel (view %match-parent %match-parent))
	(s0 (scroll 200.0 %match-parent ))
	(s1 (scroll %fill-rest %match-parent ))
	(file-tree (icon-tree 260.0 200.0 "   scheme-lib"))
	(editor (edit %match-parent %match-parent (readlines "http-test.ss") ))
	(about (dialog 240.0 180.0 320.0 200.0 "关于鸭子编辑器"))
	(syn (init-syntax))
	)

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
    (widget-set-padding file-tree 40.0 20.0 20.0 20.0)

    ;;(make-file-tree file-tree "..")
    (make-file-tree file-tree "/Users/evil/dev/lisp/scheme-lib/")

    (set! ed editor)

    (add-keyword syn "if")
    (add-keyword syn "define")
    (add-keyword syn "import")
    (add-keyword syn "display")
    (add-keyword syn "set!")
    (add-keyword syn "def-function")
    (add-keyword syn "def-function-callback")
    (add-identify syn "=")
    
    (widget-set-attrs s0 'background #x272822)
    (widget-set-attrs s1 'background #x272822)

    ;;dracula theme
    (add-color syn 'identity #xff95f067)
    (add-color syn 'number #xffbd93f9)
    (add-color syn 'comment #xff6272a4)
    (add-color syn 'string #xfff1fa8c)
    (add-color syn 'keyword #xffff79c6)
    (add-color syn 'normal #xfff8f8f2)
    (widget-set-attrs editor 'select-color #xff44475a)
    (widget-set-attrs editor 'cursor-color #xfff8f8f0)
    (widget-set-attrs s0 'background #x282a36)
    (widget-set-attrs s1 'background #x282a36)
    (widget-set-attrs editor 'font "Roboto-Regular.ttf")
    (widget-set-attrs editor 'font-size 44.0)
    (widget-set-attrs editor 'font-line-height 1.2)

    (widget-set-attrs editor 'syntax syn)
    (widget-set-attrs editor 'syntax-on #t)

    (widget-add s0 file-tree)
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

(define (duck-editor)
  (set! window (window-create width height "鸭子编辑器"))
  (window-set-fps-pos 750.0 0.0)
  (window-set-fps-pos  0.0  0.0)
  ;;(window-set-wait-mode #f)
  ;;(window-show-fps #t)
  ;;load res
  (init-res)
  ;;ui init here
  (init-editor)

  ;;run
  (window-loop window)
  (window-destroy window)
  )

(duck-editor)

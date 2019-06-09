;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(define (save-file filename content)
  (let ((p (open-output-file filename 'replace)))
    (display content p)
    (close-output-port p)))



(define (file-browser path) 
    (let  ((d (dialog 240.0 180.0 680.0  400.0 "文件管理"))
            (input (edit 400.0 40.0 path))
            (open (button 80.0 40.0 "打开"))
            (close (button 80.0 40.0 "取消"))
            (list-scroll (scroll 620.0 280.0  ))
            (t (tree %match-parent %match-parent "上级"))
            )
        

         (define (string-trim str  t)
            (list->string (remove! t (string->list str)))
         )

        (define (make-file-list tree path)
            (let loop ((files (directory-list path)))
                (if (pair? files)
                (let ((n (icon-tree  200.0 200.0  (car files) )))
                (if (file-directory? (path-append path  (car files)))
                    (widget-set-attrs n 'dir #t))
                (widget-set-attrs n 'path path)
                (widget-set-events
                    n
                    'click
                    (lambda (w p type data)
                        (printf "select ~a\n" (path-append path (car files)) )
                        (if (file-directory? (path-append path (car files)) )
                            (begin
                                (reload-file-list (path-append path (car files)) )
                            ))
                        (widget-set-attr input %text (path-append path (car files)))
                    )
                )
                (widget-add tree n) 
                (loop (cdr files)))
                ))
            )
        (define (reload-file-list file)
            (widget-set-child t '())
            (make-file-list t file)
            (printf "file=~a\n" file)
            (widget-layout-update (widget-get-root t))
        )

        ;;(widget-set-padding input 10.0 10.0 0.0 0.0)
        (widget-set-margin input 10.0 10.0 0.0 0.0)
        (widget-set-margin open 10.0 10.0 0.0 0.0)
        (widget-set-margin list-scroll 10.0 10.0 10.0 0.0)
        (widget-add d input)
        (widget-add d open)
        (widget-add d close)
        (widget-add d list-scroll)
        (widget-add list-scroll t)
        (widget-set-attrs input 'border #xff6273a1)
        (widget-set-attrs input 'background #xff20232c)
        (widget-set-attrs list-scroll 'background #xff20232c)
        (make-file-list t path)

         (widget-set-events 
                close 'click
                (lambda (w p type data)
                    (widget-set-attr d %visible #f)
                ))
         (widget-set-events 
                t 'click
                (lambda (w p type data)
                    (let ((path (path-parent (widget-get-attr input %text))))
                    (printf "go upper\n")
                    (widget-set-attr input %text path)
                    (reload-file-list path))
                ))
         (widget-set-events 
                open 'click
                (lambda (w p type data)
                    (let ((file (string-trim (widget-get-attr input %text) #\newline)))
                            (if (file-directory? file)
                                (begin
                                    ;;(reload-file-list file)
                                    (set-var 'work.dir file)
                                    (widget-set-attr d %visible #f)
                                )
                                (if (file-exists? file )
                                    (begin 
                                        (set-var 'editor.file file)
                                        (widget-set-attr (get-var 'editor) %text (readlines2 file ) )
                                        (widget-set-attr d %visible #f))
                                    (printf "file not exist ~a\n" file))
                                    ))
                ))
    
    ;;(widget-add d)
    ;;(widget-layout-update (widget-get-root d))
    d  
    ))

(register 'menu.bar (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (file-tree (get-var duck 'tree ))
          (header (get-var duck 'menu ))
          (s0 (get-var duck 'tree.scroll ))
          (work-dir (get-var duck 'work.dir ))
          (about (dialog 240.0 180.0 320.0 200.0 "关于鸭子编辑器"))
          )

        ;;set header
        (let ((menu-file (pop 60.0 30.0 "文件"))
            (menu-edit (pop 60.0 30.0 "编辑"))
            (menu-setting (pop 60.0 30.0 "设置"))
            (menu-help (pop 60.0 30.0 "帮助"))
            (menu-search (pop 60.0 30.0 "查找"))
            (menu-open (pop 60.0 30.0 "打开"))
            (menu-save (pop 60.0 30.0 "保存"))
            (menu-quit (pop 60.0 30.0 "退出"))
            (menu-about (pop 60.0 30.0 "关于"))
            ;;(file-list (file-browser work-dir) )
            )
            (widget-set-events
                menu-quit 'click
                (lambda (w p type data)
                    (exit)
                    ))

            (widget-set-events
                menu-save 'click
                (lambda (w p type data)
                    (printf "save file ~a ~a\n"  (get-var 'editor.file) (string-length (widget-get-attr editor %text )))
                    (save-file (get-var 'editor.file) (widget-get-attr editor %text ))
                    ))

            (widget-add header menu-file)
            (widget-add header menu-edit)
            (widget-add header menu-search)
            (widget-add header menu-setting)
            (widget-add header menu-help)
            ;;(widget-add header menu-empty)
            ;;(widget-add file-list )
            

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
            (let ((info (edit 300.0 120.0 "scheme-lib 是一个scheme使用的库。目前支持android mac linux windows，其它平台在规划中。官方主页啦啦啦啦gagaga：http://scheme-lib.evilbinary.org/ QQ群：Lisp兴趣小组239401374 啊哈哈"))
                (close (button 120.0 30.0 "关闭"))
                )
            (widget-add about info)
            (widget-add about close)
            (widget-add about)
            (widget-set-attr about %visible #f)

            ;;(widget-set-margin close 0.0 0.0 100.0 100.0)
            (widget-set-attrs info 'editable #f)
            (widget-set-events
                close 'click
                (lambda (w p type data)
                    (widget-set-attr about %visible #f)))
            (widget-set-events
                menu-about 'click
                (lambda (w p type data)
                    (printf "click abount\n")
                    (widget-set-attr about %visible #t)))

            (widget-set-events 
                menu-open 'click
                (lambda (w p type data)
                    (if (null? (get-var 'file-browser))
                        (let ((fb (file-browser work-dir)))
                            (set-var 'file-browser fb)
                            (widget-add fb))
                        (begin 
                            (widget-set-attr (get-var 'file-browser) %visible #t)
                            ;;(widget-layout-update (widget-get-root (get-var 'file-browser)))
                        ))
                ))
        )

    ))))

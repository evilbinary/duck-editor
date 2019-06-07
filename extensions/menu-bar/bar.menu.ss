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
            (menu-help (pop 60.0 30.0 "帮助"))
            (menu-search (pop 60.0 30.0 "查找"))
            (menu-open (pop 60.0 30.0 "打开"))
            (menu-save (pop 60.0 30.0 "保存"))
            (menu-quit (pop 60.0 30.0 "退出"))
            (menu-about (pop 60.0 30.0 "关于"))
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
        )

    ))))
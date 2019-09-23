;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))
(import duck.browser duck.tree duck.file duck.menu)

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
            (menu-tool (pop 60.0 30.0 "工具"))


            (menu-open (icon-pop 120.0 30.0 "打开" "open.png" "C-o"))
            (menu-save (icon-pop 120.0 30.0 "保存" "save.png" "C-s"))
            (menu-quit (icon-pop 120.0 30.0 "退出" "exit.png" "C-q"))
            (menu-about (icon-pop 120.0 30.0 "关于" "about.png" ""))
            (menu-manual (icon-pop 120.0 30.0 "文档" "manual.png" ""))
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
            ;;(widget-add header menu-setting)
            (widget-add header menu-tool)
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
            (widget-set-attrs menu-tool 'root #t)
            ;;(widget-set-attrs menu-setting 'root #t)
            
        
            ;;(widget-set-attrs menu-empty 'is-root #t)

            (widget-add menu-file menu-open)
            (widget-add menu-file menu-save)
            ;;preference setting
            (let ((preference (icon-pop 120.0 30.0 "偏好" "perffernce.png" "C-p")))
                (widget-add menu-file preference)
            )

            ;;edit 
            (let ((undo (icon-pop 120.0 30.0 "撤销" "undo.png" "C-z"))
                  (redo (icon-pop 120.0 30.0 "重做" "redo.png" "C-S-z"))
                  (copy (icon-pop 120.0 30.0 "拷贝" "copy.png" "C-c"))
                  (paste (icon-pop 120.0 30.0 "粘贴" "paste.png" "C-v"))
                )
                (widget-add menu-edit undo)
                (widget-add menu-edit redo)
                (widget-add menu-edit copy)
                (widget-add menu-edit paste)
            )

             ;;search 
            (let ((find (icon-pop 120.0 30.0 "查找" "find.png" "C-f"))
                  (replace (icon-pop 120.0 30.0 "替换" "replace.png" "C-r"))
                )
                (widget-add menu-search find)
                (widget-add menu-search replace)
            )
             ;;tools 
            (let ((cmd (icon-pop 120.0 30.0 "命令行" "shell.png" ""))
                  (chat (icon-pop 120.0 30.0 "聊天" "chat.png" ""))
                )
                (widget-add menu-tool cmd)
                (widget-add menu-tool chat)
            )



            (widget-add menu-file menu-quit)
            (widget-add menu-help menu-manual)
            (widget-add menu-help menu-about)

       
            ;;set abount
            (let ((info (edit %match-parent 120.0 "鸭子编辑器v1.0,群：Lisp兴趣小组239401374"))
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

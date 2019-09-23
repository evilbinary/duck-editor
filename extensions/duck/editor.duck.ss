;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Copyright 2016-2080 evilbinary.
;;作者:evilbinary on 12/24/16.
;;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

(module duck.keys (init-key-map 
                     get-default-key-map
                    set-key-map set-key-status 
                    is-key-press process-keys-map)

(define all-key-func (make-hashtable equal-hash equal?))
(define all-keys-status (make-hashtable equal-hash equal?) )
(define default-key-map (make-hashtable equal-hash equal?))
(define default-key-maps 
    (list
        '(ctl 341)
        '(shift 340)
        '(alt 342)
        '(tab 258)
        '(caps-lock #x0010)
        '(num-lock #x0020)
        '(a 65)
        '(b 66)
        '(c 67)
        '(d 68)
        '(v 86)
        '(x 88)
        '(enter 257)
        '(backspace 259)
        '(/ 47)
        '(cmd 343)
        '(esc 256)
    ))

(define (set-default-key-map key val)
    (hashtable-set! default-key-map key val))

(define (get-default-key-map key)
    (hashtable-ref default-key-map key '()))

(define (init-key-map)
    (let loop ((l default-key-maps))
        (if (pair? l)
        (begin 
            ;;(printf "~a ~a ~a\n" (car l) (caar l)  (cadar l))
            (set-default-key-map (caar l) (cadar l))
            (set-default-key-map  (cadar l) (caar l))
            (loop (cdr l))
        ))))

(define (set-key-status key action)
    (hashtable-set! all-keys-status key action)
)
(define (is-key-press key)
    (hashtable-ref all-keys-status (get-default-key-map key) '()))

(define (is-multi-key-press keys)
    (= (length keys) 
        (length (filter (lambda (x )
                    (let ((ret (is-key-press x) ))
                    (if (null? ret)
                        #f
                        (begin 
                        ;;(printf ">0 ~a\n" (> ret 0))
                        (> ret 0))
                     )))
                keys))))

(define (set-key-map keys fun)
    (hashtable-set! all-key-func keys fun))

(define (get-key-map keys)
    (hashtable-ref all-key-func keys '()))


(define (process-key-map keys)
    (if (is-multi-key-press keys )
        (let ((fun (get-key-map keys )))
            (fun))
    ))

(define (process-keys-map)
    (let loop ((k (vector->list (hashtable-keys all-key-func))))
        (if (pair? k)
            (begin 
                (process-key-map (car k))
                (loop (cdr k))
            )
        )
    ))
)

(module duck.snippets (pop-snippets show-snippets set-snippets-pos show-snippets-pos hide-snippets)
    (import duck.keys)
    (define (pop-snippets)
        (let ( (p (view  380.0 430.0  ) )
                )
            (let loop ((child (widget-get-child p)))
                (if (pair? child)
                    (begin 
                        (widget-set-attrs (car child) 'text-align 'left)
                        (widget-set-attrs (car child) 'padding-left 18.0)
                    (loop (cdr child))
                    )))
            
            (widget-set-attrs p 'background #x010000ff)
            (widget-add-event p 
                (lambda (widget parent type d)
                    (if (= type %event-key)
                        (if (equal? 'enter  (get-default-key-map (vector-ref d 0)))
                            (begin
                                (printf "enter\n")
                                (hide-snippets)
                                (printf "focus-child ~a\n"  (widget-get-attrs (get-var 'editor.snippets) 'focus-child ) )
                                (if (not (null? (widget-get-attrs (get-var 'editor.snippets) 'focus-child )))
                                    (set-var 'editor.snippets.text 
                                        (widget-get-attr (widget-get-attrs (get-var 'editor.snippets) 'focus-child ) %text)))
                                ;;(printf "visible=>~a\n" (widget-get-attr (get-var 'editor) %visible ))
                                ;;(widget-layout-update (widget-get-root p))
                            )
                        )
                        ;;(printf "key ~a\n" (get-default-key-map (vector-ref d 0)))
                    ))
            )
            p
        )
    )

    (define (show-snippets-pos lx ly )
        (let ((snippets (get-var 'editor.snippets)))
            (widget-set-xy snippets lx ly)
            (widget-set-status snippets %status-active)
            (widget-clear-status (get-var 'editor) %status-active)
            (widget-set-attr snippets %visible #t)
            ;;(widget-layout-update (widget-get-root snippets))
        ))
    (define (hide-snippets )
     (let ((snippets (get-var 'editor.snippets)))
        (widget-clear-status snippets %status-active)
        (widget-set-attr snippets %visible #f)
        (widget-set-status (get-var 'editor) %status-active)
         )
    )

    (define (show-snippets . lst)
        (let ((snippets (get-var 'editor.snippets)))
        (widget-set-status snippets %status-active)
        (widget-clear-status (get-var 'editor) %status-active)
        (widget-set-attr snippets %visible #t)
        (if (> (length lst) 0)
            (set-snippets-child snippets (list-ref lst 0)))
        )
    )

    (define (set-snippets-child snippets lst)
        (widget-set-child snippets '())
        (let loop ((c lst))
            (if (pair? c)
              (begin
                ;(printf "=>~a\n" (car c))
                (widget-add snippets (button 380.0 30.0 (car c) ) )
                (loop (cdr c))
                )))
        (let loop ((child (widget-get-child snippets)))
                (if (pair? child)
                    (begin 
                        (widget-set-attrs (car child) 'text-align 'left)
                        (widget-set-attrs (car child) 'padding-left 18.0)
                    (loop (cdr child))
                    )))
        (widget-layout-update snippets)
    )

    (define (set-snippets-pos lx ly )
        (let ((snippets (get-var 'editor.snippets)))
            (widget-set-xy snippets lx ly)
            ;;(widget-layout-update (widget-get-root snippets))
        )
    )
)

(module duck.file (readlines read-line readlines2 save-file)
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
        (buf (cffi-alloc 1028))
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
(define (save-file filename content)
  (let ((p (open-output-file filename 'replace)))
    (display content p)
    (close-output-port p)))
)

(module duck.image (image-dialog image-view)
    (define (image-view w h src)
        (let ((img (image w h src))
                (file-name src))
            ;;(widget-set-attrs img 'mode 'center-crop)
            (if (file-exists? file-name)
                (begin
                (widget-set-attrs img 'src file-name)
                (widget-set-attrs img 'load #f))
                ;;(window-post-empty-event)
                )
            img
            ))

    (define (image-dialog w h src)
        (let  ((d (dialog 240.0 180.0 (+ w 80.0) (+ h 120.0) src))
                (close (button 120.0 30.0 "关闭"))
                (img (image-view w h src)) )
            ;;(widget-set-margin close 60.0 40.0 40.0 40.0)
            ;;(widget-set-margin img 60.0 40.0 40.0 40.0)
            (widget-add d img)
            (widget-add d close)
            (widget-set-events
                close 'click
                (lambda (w p type data)
                (widget-set-attr d %visible #f)
                ))
            d
        )
    )

)
(module duck.menu (icon-pop )
    (import (gui stb))
    
    (define (icon-pop w h text src shot-key)
        (let ((it (pop w h text))
            (icon '()))
            (if (not (null? src))
                (set! icon (load-texture (path-append (get-var 'resources.dir) src) )))
            (widget-set-attrs it 'icon icon)
            (widget-set-attrs it 'shot-key shot-key)
            (widget-set-attrs it 'text-align 'left)
            (widget-set-attrs it 'padding-left 40.0)
            (widget-add-draw
            it
            (lambda (w p)
            (let ((x (vector-ref w %gx))
                (y (vector-ref w %gy)))
                (if (null? (widget-get-attrs w 'icon))
                    '()
                    (begin 
                        (if (string? shot-key)
                            (draw-text (+  x 80.0) (+ y 2.0) shot-key))
                        (draw-image (+ 10.0 x) (+ y 6.0) 18.0 18.0 (widget-get-attrs w 'icon)))))
            ))
            it
            ))

)

(module duck.tree (icon-tree make-file-tree reload-file-tree init-tree-res)
    (import duck.file duck.image)
    (define (icon-tree w h text)
        (let ((it (tree w h text)))
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
        (if (file-directory? (path-append path  (widget-get-attr w %text)))
            (begin
            (widget-set-attrs w 'dir #t)
            (widget-set-child w '())
            (make-file-tree w (path-append path (widget-get-attr w %text)  "/") )
            (widget-layout-update (widget-get-root w))
            )
            (let ((file (path-append path  (widget-get-attr w %text)))
                (ext (path-extension (widget-get-attr w %text))))
            ;;(printf "ed select ~a\n"  (string-append path  (widget-get-attr w %text)) )
            (if (member ext '("jpg" "png" "jpeg"))
                (let ((d (image-dialog 400.0 400.0 file) ))
                    (widget-add d)
                    (widget-layout-update d)
                )
                (begin 
                    (set-var 'editor.file file)
                    (printf "open select ~a\n" file)
                    (widget-set-attr (get-var 'editor) %text (readlines  file) )
                    ))
            )
            )
        )))

    (define (make-file-tree tree path)
        (let loop ((files (directory-list path)))
            (if (pair? files)
            (let ((n (icon-tree  200.0 200.0  (car files) )))
            (if (file-directory? (path-append path  (car files)))
                (widget-set-attrs n 'dir #t))
            (widget-set-attrs n 'path path)
            (widget-set-events
            n
            'click
            tree-item-click
            )
            (widget-set-attrs n 'color (widget-get-attrs tree 'color ))
            (widget-add tree n) 
            (loop (cdr files)))
            ))
        )

    (define (reload-file-tree t file)
                (widget-set-child t '())
                (make-file-tree t file)
                (widget-layout-update (widget-get-root t))
                (printf "(path-last file)=~a\n" (path-last file) )
                (widget-set-attr t %text (string-append "  "  (path-last file) ))
                (printf "(widget-get-attr w %text)=>~a\n" (widget-get-attr t %text) )
            )
    (define file-icon -1) 
    (define dir-icon -1) 
    (define dir-icon-open  -1)

    (define (init-tree-res)
        (let ((resources-dir (get-var 'resources.dir)))
        (set! file-icon (load-texture (path-append resources-dir "file-text.png")))
        (set! dir-icon (load-texture (path-append resources-dir "folder.png")))
        (set! dir-icon-open (load-texture (path-append resources-dir "folder-open.png")))
    ))
)

(module duck.browser (file-browser)
(import duck.file duck.tree)
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
        (widget-set-status t  %status-active)

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
)
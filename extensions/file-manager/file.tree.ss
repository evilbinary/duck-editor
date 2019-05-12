;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;作者:evilbinary on 12/24/16.
;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (extensions extension))

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
(define ed -1)
(define file-icon -1) 
(define dir-icon -1) 
(define dir-icon-open  -1)
(define resources-dir (get-var 'resources.dir))

(define (init-res)
  (set! file-icon (load-texture (string-append resources-dir "file-text.png")))
  (set! dir-icon (load-texture (string-append resources-dir "folder.png")))
  (set! dir-icon-open (load-texture (string-append resources-dir "folder-open.png")))
)

(register 'tree.file-manager (lambda (duck)
    (let ((editor (get-var duck 'editor))
          (file-tree (get-var duck 'tree ))
            (s0 (get-var duck 'tree.scroll ))
          )
        (set! ed editor)
        ;;here
        (init-res)
        (if (null? file-tree )
            (begin 
            (set! file-tree (icon-tree 260.0 200.0 "   scheme-lib"))
            (set-var 'tree file-tree)))
        (make-file-tree file-tree "../")
        (widget-add s0 file-tree)
        (widget-set-padding file-tree 40.0 20.0 20.0 20.0)
        (widget-set-attr editor %text (readlines "http-test.ss") )

    )))
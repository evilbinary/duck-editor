;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;作者:evilbinary on 11/19/17.
;;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(library (extensions extension)
  (export
    get-var
    set-var
    register
    unregister
    get-extension
    load-extension
    load-extensions
    duck-extensions
    duck-global
    path-append
   )
  
  (import (scheme) (utils libutil) (cffi cffi) (utils macro) )

  (define-syntax path-append 
    (syntax-rules ()
      ((_ p a ...)
        (string-append p (string (directory-separator)) a ...))))

  (define duck-extensions (make-hashtable equal-hash equal?))
  (define duck-global (make-hashtable equal-hash equal?) )

  (define (register name proc)
    (if (hashtable-contains? duck-extensions name)
      (printf "extension ~a allready exists!\n" name))
      (hashtable-set! duck-extensions name proc)
    )
    
  (define (unregister name)
    (hashtable-delete! duck-extensions name ))

  (define (get-extension name)
    (hashtable-ref duck-extensions name '()))

  (define (load-extension file)
    (printf "loading... ~a\n" (path-append (get-var 'extensions.dir) file) )
    (load (path-append (get-var 'extensions.dir) file))
  ) 
  
  (define (load-extensions x)
    (let-values ([(keyvec valvec) (hashtable-entries x)])
        (vector-for-each
          (lambda (key val)
          (printf "load extensions >~s ~s \n" key val)
            (if (procedure? val)
              (val duck-global)
            ))
          keyvec valvec)))

  (define get-var
     (case-lambda
     [(duck name)
      (hashtable-ref duck name '() )]
     [(name)
     (hashtable-ref duck-global name '() )]    
     )
  )

  (define set-var
   (case-lambda
     [(duck name val)
      (hashtable-ref duck name val)]
     [(name val)
     (hashtable-set! duck-global name val )]    
     ))
)
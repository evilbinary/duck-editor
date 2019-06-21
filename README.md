# Duck Editor
Duck Editor [https://github.com/evilbinary/duck-editor](https://github.com/evilbinary/duck-editor)    
A Highly scalable Editor based on `scheme` with GPU rendering.

## Features
  1. Faster than [vscode](https://code.visualstudio.com/)
  2. More flexible then [emacs](https://www.gnu.org/software/emacs/)

## Contributing
  Duck Editor Development Team `QQ Group Number: 590540178`  

## Screen Shot
<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo4.jpg" width="800px" />

<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo2.png" width="800px" />

## Usage
   Based on [scheme lib](https://github.com/evilbinary/scheme-lib)    
   ```bash
   ./scheme --script ../apps/duck-editor/duck-editor.ss
   ```

## Extensions

### Extensions List 
1. Scheme Grammar Highlights 
2. dracula Theme
3. File System

### Develop Extensions  
#### Rigister Extension
```scheme
  (import (extensions extension))
  (register 'theme.dracula (lambda (duck)
    (let ((editor (get-var duck 'editor))
    	;; Code block for extension function.
    ))
```

#### Hook Key Control
```scheme
   (set-key-map '(ctl a) (lambda()
            (printf "hook key ctl a\n")
       ))
```

## Author

* evilbinary rootdebug@163.com
* Blog http://evilbinary.org

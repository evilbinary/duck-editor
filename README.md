# duck-editor
鸭子编辑器 [https://github.com/evilbinary/duck-editor](https://github.com/evilbinary/duck-editor)  
基于scheme开发的，GPU渲染，高可扩展。

## 特点 
  1. 比vscode快
  2. 比emacs更灵活

## 效果图
<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo4.jpg" width="800px" />

<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo2.png" width="800px" />

## 运行
   基于[scheme lib](https://github.com/evilbinary/scheme-lib)库运行   
   进入bin目录，执行source env.sh，然后运行./scheme --script ../apps/duck-editor/duck-editor.ss
## 扩展
支持可扩展
### 已有扩展  
1. scheme 语法高亮
2. dracula 主题
3. 文件管理

### 扩展开发  
#### 注册扩展  
```scheme
  (import (extensions extension))
  (register 'theme.dracula (lambda (duck)
    (let ((editor (get-var duck 'editor))
    	;;扩展功能代码块
    ))
```

#### 按键定义处理   
```scheme
   (set-key-map '(ctl a) (lambda()
            (printf "hook key ctl a\n")
       ))
```

## 作者

* evilbinary rootdebug@163.com
* 个人博客 http://evilbinary.org

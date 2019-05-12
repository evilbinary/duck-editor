# duck-editor
鸭子编辑器 [https://github.com/evilbinary/duck-editor](https://github.com/evilbinary/duck-editor)  

## 效果图
<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo4.jpg" width="800px" />

<img src="https://raw.githubusercontent.com/evilbinary/duck-editor/master/data/screenshot/demo2.png" width="800px" />



## 扩展
支持可扩展
### 已有扩展  
1. scheme 语法高亮
2. dracula 主题
3. 文件管理

### 扩展开发

```scheme
  (import (extensions extension))
  (register 'theme.dracula (lambda (duck)
    (let ((editor (get-var duck 'editor))
    	;;扩展功能代码块
    ))
```
## 作者

* evilbinary rootdebug@163.com
* 个人博客 http://evilbinary.org

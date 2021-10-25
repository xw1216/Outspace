---
title: Markdown 写法使用案例库说明
date: 2021-10-25 17:52:19
categories: 教程
tags:
  - 指南
  - 教程
  - Markdown
cover: https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/20201110_101713.jpg
katex: true
---



# Markdown 写法使用案例说明



> 本案例使用 类 `Atx` 格式标准。



## Chapter 1 Markdown 基本文字语法



### 标题

共有 `1~6` 不同级别的标题。

```markdown
# 这是一个一级标题
## 这是一个二级标题
###### 这是一个六级标题
```





### 字体效果

可以显示**加粗**，*斜体*，~~删除线效果~~ 。

```markdown
**加粗**
*斜体*
~~删除线~~
```

如需加入普通符号，使用 `\` 进行转义。





### 分割线

使用 `3` 个以上的 `*` ,  `-` ，`_` 建立分割线。

```markdown
___
***
---
```

___





### 引用块

使用 `>` 标识一个引用块。

```markdown
> This is a blockquote. It can contains a paragraph.

> > This a nested blockquote.
```

> This is a blockquote. It can contains a paragraph.
>
> > This a nested blockquote.

引用块内可以嵌套其他 Markdown 语法元素。





### 列表

> 所有的列表项都会嵌套并改变多级列表前的指示符号。
>
> 定义列表不被 	`Typora` 支持。



#### 无序列表

```markdown
- 列表项
- 列表项
- 列表项
```

- 列表项
- 列表项
- 列表项



#### 有序列表

```markdown
1. 列表项
2. 列表项
3. 列表项
```

1. 列表项
2. 列表项
3. 列表项





### 表格

```markdown
| 表头 | 表头 | 表头 |
| :--: | :--: | :--: |
| 内容 | 内容 | 内容 |
| 内容 | 内容 | 内容 |
| 内容 | 内容 | 内容 |
```

| 表头 | 表头 | 表头 |
| :--: | :--: | :--: |
| 内容 | 内容 | 内容 |
| 内容 | 内容 | 内容 |
| 内容 | 内容 | 内容 |



使用冒号表示该列的对齐方式。





### 代码

#### 单行代码

```markdown
`#include <iostream>`
```

`#include <iostream>`



#### 多行代码

````markdown
```c++
#include <iostream>
using namespace std;
```
````



```c++
#include <iostream>
using namespace std;
```





### 段落与换行

`Markdown` 段落前后要有一个以上的空行。

- 使用 <kbd>Shift</kbd> + <kbd>Enter</kbd> 可以实现段内换行。源码表现为一个空行。
- 使用 <kbd>Enter</kbd> 可以实现文本块的换行。源码表现为两个空行。

<br>



## Chapter 2  Markdown 扩展功能语法



### 超链接

#### 基本方式

```markdown
这是一个指向 [必应](https://www.bing.com) 的链接。
```

这是一个指向 [必应](https://www.bing.com) 的链接。



#### 参考方式

```markdown
这是一个先使用，后定义的 [必应][Bing] 脚注链接。
[Bing]: https://www.bing.com "Bing Link"
```

只是一个先使用，后定义的 [必应][Bing] 链接。

[Bing]: https://www.bing.com "Bing Link"



#### 简洁方式

```markdown
<https://bing.com>
```

<https://bing.com>



- 注意超链接内部没有空格。
- 同样支持 `HTML` 中的 `<a>` 标签。





### 图片

#### 基本方式

```markdown
![替换内容](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/20201110_101713.jpg)
```

![替换内容](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/20201110_101713.jpg)



- 图片也可以使用上文中超链接一样的参考方式引入。
- 通常将图片上传至图床网站，然后以 `URL` 链接引入。
- 此外还可以将图片放置在指定位置，使用相对路径或绝对路径访问。
- 图片也支持 `HTML` 中`<img>`标签，并设置对齐方式，大小以及缩放比。





### 公式

#### 行内公式

```markdown
$ \sum_{i=1}^{n}{\log{\alpha}} $
```

> 似乎博客的渲染器不支持行内公式渲染。 :cry:



#### 块级公式

```markdown
R_{\theta} = \begin{bmatrix} 
\cos{\theta} \quad -\sin{\theta} \\
\sin{\theta} \quad \cos{\theta}
\end{bmatrix}\\
R_{-\theta} = \begin{bmatrix} 
\cos{\theta} \quad \sin{\theta} \\
-\sin{\theta} \quad \cos{\theta}
\end{bmatrix}\\
R_{-\theta} = R_{\theta}^{T}\\
R_{-\theta} = R_{\theta}^{-1}
```

$$
R_{\theta} = \begin{bmatrix} 
\cos{\theta} \quad -\sin{\theta} \\
\sin{\theta} \quad \cos{\theta}
\end{bmatrix}\\
R_{-\theta} = \begin{bmatrix} 
\cos{\theta} \quad \sin{\theta} \\
-\sin{\theta} \quad \cos{\theta}
\end{bmatrix}\\
R_{-\theta} = R_{\theta}^{T}\\
R_{-\theta} = R_{\theta}^{-1}
$$

关于 `Latex` 公式的详细语法请参考 [LateX公式手册](https://www.cnblogs.com/1024th/p/11623258.html) 。





### 脚注

```markdown
Here's a sentence with a footnote. [^1]
[^1]: This is the footnote.
```

Here's a sentence with a footnote. [^1]

[^1]: This is the footnote.

>  似乎博客的渲染器不支持脚注。 :cry: 但是该功能对于论文引用十分有利。





### 任务列表

```markdown
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
```

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

> 似乎博客的渲染器不支持任务列表渲染。 :cry:





### 使用 `emoji` 表情

```mark
:tent:  很快回来。
:joy: very funny.
```

:tent:  很快回来。

:joy: very funny.



> 关于更多 Markdown 规范，请参考 [GitHub Flavored Markdown 规范](https://github.github.com/gfm/#emphasis-and-strong-emphasis)

<br>



## Chapter 3 Hexo 内置 `Tags` 标签



> 下面的内容多数参考自：
>
> - [Hexo 官方文档](https://hexo.io/zh-cn/docs/tag-plugins.html)
> - [Butterfly 主题文档](https://butterfly.js.org/)
>
> 其中 `Tag Plugin` 只能在网页中得到渲染效果。



### `Front-matter`

#### `Post Front-matter`

在 `.markdown` 文件的头部声明对应的键值，博客系统将按照响应的方法进行操作。

```markdown
---
title:
date:
updated:
tags:
categories:
keywords:
description:
top_img:
comments:
cover:
toc:
toc_number:
copyright:
copyright_author:
copyright_author_href:
copyright_url:
copyright_info:
mathjax:
katex:
aplayer:
highlight_shrink:
aside:
---
```

|                    键 | 值                                                           |
| --------------------: | :----------------------------------------------------------- |
|                 title | 【必需】文章标题                                             |
|                  date | 【必需】文章创建日期                                         |
|               updated | 【可选】文章更新日期                                         |
|                  tags | 【可选】文章标籤                                             |
|            categories | 【可选】文章分类                                             |
|              keywords | 【可选】文章关键字                                           |
|           description | 【可选】文章描述                                             |
|               top_img | 【可选】文章顶部图片                                         |
|                 cover | 【可选】文章缩略图<br />(如果没有设置top_img,文章页顶部将显示缩略图，可设为false/图片地址/留空) |
|              comments | 【可选】显示文章评论模块<br />(默认 true)                    |
|                   toc | 【可选】显示文章TOC<br />(默认为设置中toc的enable配置)       |
|            toc_number | 【可选】显示toc_number<br />(默认为设置中toc的number配置)    |
|             copyright | 【可选】显示文章版权模块<br />(默认为设置中post_copyright的enable配置) |
|      copyright_author | 【可选】文章版权模块的文章作者                               |
| copyright_author_href | 【可选】文章版权模块的文章作者链接                           |
|         copyright_url | 【可选】文章版权模块的文章连结链接                           |
|        copyright_info | 【可选】文章版权模块的版权声明文字                           |
|               mathjax | 【可选】显示mathjax<br />(当设置mathjax的per_page: false时，才需要配置，默认 false) |
|                 katex | 【可选】显示katex<br />(当设置katex的per_page: false时，才需要配置，默认 false) |
|               aplayer | 【可选】在需要的页面加载aplayer的js和css,请参考文章下面的音乐 配置 |
|      highlight_shrink | 【可选】配置代码框是否展开<br />(true/false)(默认为设置中highlight_shrink的配置) |
|                 aside | 【可选】显示侧边栏<br /> (默认 true)                         |



#### `Post Front-matter`

```markdown
---
title:
date:
updated:
type:
comments:
description:
keywords:
top_img:
mathjax:
katex:
aside:
aplayer:
highlight_shrink:
---
```

|               键 | 值                                                           |
| ---------------: | :----------------------------------------------------------- |
|            title | 【必需】文章标题                                             |
|             date | 【必需】文章创建日期                                         |
|             type | 【必需】标籤、分类和友情链接三个页面需要配置                 |
|          updated | 【可选】文章更新日期                                         |
|      description | 【可选】页面描述                                             |
|         keywords | 【可选】文章关键字                                           |
|         comments | 【可选】显示页面评论模块<br />(默认 true)                    |
|          top_img | 【可选】页面顶部图片                                         |
|          mathjax | 【可选】显示mathjax<br />(当设置mathjax的per_page: false时，才需要配置，默认 false) |
|            katex | 【可选】显示katex<br />(当设置katex的per_page: false时，才需要配置，默认 false) |
|          aplayer | 【可选】在需要的页面加载aplayer的js和css,请参考文章下面的音乐 配置 |
| highlight_shrink | 【可选】配置代码框是否展开<br />(true/false)(默认为设置中highlight_shrink的配置) |
|            aside | 【可选】显示侧边栏<br /> (默认 true)                         |





### 标签外挂

```markdown
{% note [class] [no-icon] [style] %}
Any content (support inline tags too.io).
{% endnote %}
```

| 名称    | 用法                                                         |
| ------- | ------------------------------------------------------------ |
| class   | 【可选】标识，不同的标识有不同的配色<br/>（ default / primary / success / info / warning / danger ） |
| no-icon | 【可选】不显示 icon                                          |
| style   | 【可选】可以覆盖配置中的 style<br/>（simple/modern/flat/disabled） |

{% note simple %}
默认 提示标签块
{% endnote %}

{% note default simple %}
default 提示标签块
{% endnote %}

{% note primary simple %}
primary 提示标签块
{% endnote %}

{% note success simple %}
success 提示标签块
{% endnote %}

{% note info simple %}
info 提示标签块
{% endnote %}

{% note warning simple %}
warning 提示标签块
{% endnote %}

{% note danger simple %}
danger 提示标签块
{% endnote %}





### `Gallary` 相册图库

```markdown
<div class="gallery-group-main">
{% galleryGroup name description link img-url %}
{% galleryGroup name description link img-url %}
{% galleryGroup name description link img-url %}
</div>
```

| 键          | 值                   |
| ----------- | -------------------- |
| name        | 图库名               |
| description | 图库描述             |
| link        | 链接到对应的相册地址 |
| img-url     | 图库封面的地址       |



<div class="gallery-group-main">
{% galleryGroup '插画' 收藏的优雅二次元！ '/gallary/inset/' https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/20201110_101713.jpg %}
{% galleryGroup '照片' 收藏的好康摄影！ '/gallary/photo/' https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/background.png %}
</div>





### `Gallary` 相册

```markdown
{% gallery %}
![]()
{% endgallery %}
```

{% gallery %}
![](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/background.png)
![](https://raw.githubusercontent.com/xw1216/ImageHosting/main/img/e6e09d1b09711bb40fa672450aafd3405690bb121080.png)

{% endgallery %}





### 文字隐藏

```markdown
{% hideInline content,display,bg,color %}

{% hideBlock display,bg,color %}
content
{% endhideBlock %}

{% hideToggle display,bg,color %}
content
{% endhideToggle %}
```

{% hideToggle Butterfly安装方法 %}
在你的博客根目录里

git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/Butterfly

如果想要安装比较新的dev分支，可以

git clone -b dev https://github.com/jerryc127/hexo-theme-butterfly.git themes/Butterfly

{% endhideToggle %}





### 页内标签

```markdown
{% tabs Unique name, [index] %}
<!-- tab [Tab caption] [@icon] -->
Any content (support inline tags too).
<!-- endtab -->
{% endtabs %}

Unique name   : Unique name of tabs block tag without comma.
                Will be used in #id's as prefix for each tab with their index numbers.
                If there are whitespaces in name, for generate #id all whitespaces will replaced by dashes.
                Only for current url of post/page must be unique!
[index]       : Index number of active tab.
                If not specified, first tab (1) will be selected.
                If index is -1, no tab will be selected. It's will be something like spoiler.
                Optional parameter.
[Tab caption] : Caption of current tab.
                If not caption specified, unique name with tab index suffix will be used as caption of tab.
                If not caption specified, but specified icon, caption will empty.
                Optional parameter.
[@icon]       : FontAwesome icon name (full-name, look like 'fas fa-font')
                Can be specified with or without space; e.g. 'Tab caption @icon' similar to 'Tab caption@icon'.
                Optional parameter.
```

{% tabs test1 %}
<!-- tab -->
**This is Tab 1.**
<!-- endtab -->

<!-- tab -->
**This is Tab 2.**
<!-- endtab -->

<!-- tab -->
**This is Tab 3.**
<!-- endtab -->
{% endtabs %}





### 页内按钮

```markdown
{% btn [url],[text],[icon],[color] [style] [layout] [position] [size] %}

[url]         : 链接
[text]        : 按钮文字
[icon]        : [可选] 图标
[color]       : [可选] 按钮背景顔色(默认style时）
                      按钮字体和边框顔色(outline时)
                      default/blue/pink/red/purple/orange/green
[style]       : [可选] 按钮样式 默认实心
                      outline/留空
[layout]      : [可选] 按钮佈局 默认为line
                      block/留空
[position]    : [可选] 按钮位置 前提是设置了layout为block 默认为左边
                      center/right/留空
[size]        : [可选] 按钮大小
                      larger/留空
```

<div class="btn-center">
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline blue larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline pink larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline red larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline purple larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline orange larger %}
{% btn 'https://butterfly.js.org/',Butterfly,far fa-hand-point-right,outline green larger %}
</div>




### 页内文字标签

```markdown
{% label [text] [color] %}

[text] 文字
[color] [可选] 背景颜色，默认为 default/blue/pink/red/purple/orange/green
```

臣亮言：{% label 先帝 %}创业未半，而{% label 中道崩殂 blue %}。今天下三分，{% label 益州疲敝 pink %}，此诚{% label 危急存亡之秋 red %}也！然侍衞之臣，不懈于内；{% label 忠志之士 purple %}，忘身于外者，盖追先帝之殊遇，欲报之于陛下也。诚宜开张圣听，以光先帝遗德，恢弘志士之气；不宜妄自菲薄，引喻失义，以塞忠谏之路也。
宫中、府中，俱为一体；陟罚臧否，不宜异同。若有{% label 作奸 orange %}、{% label 犯科 green %}，及为忠善者，宜付有司，论其刑赏，以昭陛下平明之治；不宜偏私，使内外异法也。

<br>



## Chapter 4 结语

到这里，博客内使用的绝大多数 Markdown 语法以及 Tag Plugin 语法均有提及。这一篇文章将作为写作参考，供未来的我使用。:raised_hands:

也欢迎各位来访的朋友参考！:rocket: 

 

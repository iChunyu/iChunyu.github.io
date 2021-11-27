# reStructuredText 简介


reStructuredText 是一个不同于 Markdown 的文本标记语言，通常结合 Sphinx 构建静态网站，特别适合帮助类文档的编写。这篇文章简要介绍其基本用法。

<!--more-->


## 章节标题

在标题的下一行用某一符号填充，且长度不得小于标题文字长度。标题上一行可以填充相同的内容，但不是必须的，例如下面两种方式等价：

```reStructuredText
========================================
甄士隐梦幻识通灵　贾雨村风尘怀闺秀 
========================================


甄士隐梦幻识通灵　贾雨村风尘怀闺秀 
========================================
```

应当注意，如果同时使用上面两种方式，即使使用的是同一种符号，也会被认为是不同级别的标题。标题的级别由符号使用的先后顺序决定。

标题装饰符相对比较随意，可以参考下面 [Python 风格指南](https://devguide.python.org/documenting/##sections) 的建议：

- `##` 且在标题上下两行均填充，为部（Parts）标题；
- `*` 且在标题上下两行均填充，为章（Chapters）标题；
- `=` 且在标题下填充，为节（Sections）标题；
- `-` 且在标题下填充，为子节（Subsections）标题；
- `^` 且在标题下填充，为二级子节（Subsubections）标题；
- `"` 且在标题下填充，为段落（Paragraphs）标题。

## 分割线

使用与标题装饰符号相同的符号集，连续使用4个以上，且上下都是空行，来插入分隔符。应当注意一下事项：

- 分隔线与上下内容之间需要有空白行；
- 分隔线不能紧贴在大纲标题之前或之后，也不能放在文档最开头；
- 两个分隔线不能紧贴，必须有除了空白行之外的内容。

## 列表

列表第一项之前和最后一项之后都要有空行，编号列表和非编号列表分别用 `#.` 和 `-` 后接一个空格引出，代码示例如下：

```reStructuredText
这里是一点正文。

#. 有序列表的第一项要和正文之间由空行分割；
#. 这是自动编号的有序列表的第二项。

- 这是一个无编号列表的例子；
- 注意列表起始符与列表正文之间的空格；
    - 列表的嵌套只需要缩进即可。
```

## 表格

表格分为简单表、网格表、CSV表，我直接复制了参考资料：

### 简单表

-   行分隔：以等号 `=` 标记表格的顶线与底线。
    -   每列中的行分隔符在竖直方向上必须对齐。
    -   如果有表头，表头与表身也用 `=` 分隔。
    -   在简单表中，不允许跨行。
-   列分隔：以空格来分隔列。
    -   每列的文本左侧对齐到该列行分隔符的左侧。
    -   如果需要，表中最右侧的列文本的右侧可以溢出该列的行分隔符右侧。
    -   简单表允许跨列。用横线 `-`
        来标记跨列的长度。跨列符必须与某一列的行分隔符对齐。
    -   跨列时的列间空格用 `-` 替代。
-   空白行：表内任一行内部允许文本中存在的空白行。表行之间的空白行会被忽略。
-   空白表格：用反斜线 `\` 标记空白表格。

下面是一个简单表的例子:

```reStructuredText
=======    =======
PID Controller
------------------
Items      Value
=======    =======
P          15
I          20
D          7
\          Tested
=======    =======
```


### 网格表

网格表的使用较为复杂但是更为灵活：

- 表线必须完整地围住表格文本。
- 行分隔线一律用横线 `-` 书写，除了表头分割线用等号 `=` 。
- 列分隔线一律用竖线 `|` 书写。
- 行、列分隔线的交叉点用加号 `+` 标记。

给出一个网格表的例子：

```reStructuredText
.. table:: 网格表示例
    :align: center
    :width: 40%

    +---------------------------+
    | PID Paramters             |
    +======+====================+
    | Item | Degree of Freedoms |
    |      +------+------+------+
    |      |  X   |  Y   |  Z   |
    +------+------+------+------+
    | P    | 1.0  | 2.0  | 3.0  |
    +------+------+------+------+
    | I    | 3.0  | 1.0  | 5.0  |
    +------+------+------+------+
    | D    | 2.0  | 5.0  | 7.0  |
    +------+------+------+------+
```

从这个例子可以看出，网格表可以放在 `table` 指令（[Directive: table](https://docutils.sourceforge.io/docs/ref/rst/directives.html##table)）中，并可以提供对齐、宽度等约束。指令的一般用法为：

```reStructuredText
.. directive::
    :option1: option1
    :option2: option2

    content
```

`table` 提供以下选项：

- `align` --- 对齐方式： `left` ， `center` ， `right` ；
- `widths` --- 各列的宽度： `auto` ， `grid` ，逗号或空格分割的整数序列；
- `width` --- 整个列表的宽度，给定长度或页面宽度的百分比。

当中英文混合时，网格表容易出现文字对不齐的情况，可以使用中英文等宽字体避免这种显示问题，例如可以使用 [Iosevka](https://typeof.net/Iosevka/) 字体。


### CSV表

- 表宽 `:width: LENGTH/PERCENT` 表格的总宽度，以长度值或者百分数来指定
- 列宽 `:widths: INT,INT,...` 每列的相对宽度（相对于100）可以由整数 `INT` 指定。默认各列等宽。
- 表头：有两种表示方法。
    - 表头行 `:header-rows: INT` 指定表格中的前 `INT` 行为表头。
    - 表头文本 `:header: TEXT,TEXT,...` 直接输入每一列表头的文本。它也可以与 `header-rows` 选项同时使用，但必须放在 `header-rows` 之前。
-   列头： `:stub-columns: INT` 将前 INT 列作为列头。
-   对齐： `:align: ALIGN` 用 `left`, `center` 或者 `right` 来指定整个表如何向外部环境对齐。
-   外部CSV文件： 用 `:file: FILEPATH` 引用本地文件或者 `:url: URL` 引用网络文件。

```reStructuredText
.. csv-table:: CSV Table Caption
    :header: "First Name", "Age", "Gender"
    :widths: 30, 20, 20
    :width: 60%
    :align: center

    "Tom", 3, Male
    "Dick", 5
    "Harry",, Male
```

## 图片

指令 `image` （[Directive: image](https://docutils.sourceforge.io/docs/ref/rst/directives.html##image)）和 `figure` （[Directive: figure](https://docutils.sourceforge.io/docs/ref/rst/directives.html##figure)）都可以用来插图，但前者不能插入图名，因此这里用一个例子介绍后者的用法。

```reStructuredText
.. figure:: figures/kasugano.png
    :alt: 当图片无法显示时候用于代替的文本
    :width: 80%
    :align: center
    :target: https://github.com/iChunyu

    与 ``image`` 相比， ``figure`` 在这里可以插入标题甚至段落。
```


## 超链接

两种超链接使用方法如下，一种是直接使用，一种是先定义别名，再给出链接。后者适合正文多次使用该超链接时使用。

```reStructuredText
`bilibili <https://www.bilibili.com/>`_ 干杯！


`Git`_ 是一个版本管理软件， 它的官网为： `Git`_ 。

.. _Git: https://git-scm.com
```

## 交叉引用

在需要引用的位置的空一行使用 `.. _some-label:` 打上标签，然后可以在文中任意位置使用 `` :ref:`some-label` `` 进行引用。

例如：

```reStructuredText
.. _corss-ref:

交叉引用
-----------------------------------------------

（正文略）

交叉引用的使用方法可以查看： :ref:`corss-ref` 。
```

除正文交叉引用，还常用到项目内文件的交叉引用，例如 `` :doc:`learn_git` `` 可以应用项目内的其他文档 。

## 脚注

脚注的在正文中用 `[##fn]_` 标记，一般在文末通过 `.. [##fn] 文本`
给出脚注内容。示例如下：

```reStructuredText
这是一个脚注 [##footnotemark]_ 。

.. [##footnotemark] 这是脚注的内容。
```

## 代码

正文内代码用一对反引号即可，例如 ``code`` ，对于代码块，可以使用 `code-block` 指令，例如：

```reStructuredText
.. code-block:: python

    import numpy as np
    import matplot.pyplot as plt
```

## 数学公式

类似代码，行内公式可以使用 `` :math:`\sin\alpha` `` 这种形式，单行或多行公式可以在 `:math:` 指令中使用 $\\LaTeX$ 扩展。例如：

``` 
.. math::
    \left\{
    \begin{aligned}
        \sin\left( \alpha+\beta \right) &= \sin\alpha \cos\beta + \cos\alpha \sin\beta \\
        \cos\left( \alpha+\beta \right) &= \cos\alpha \cos\beta - \sin\alpha \sin\beta
    \end{aligned}
    \right.
```


## 警示标记

警示标记是一类指令，可以生成特别的消息框，使用方法如下：

``` 
.. warning:: 

    这是一个警告标记。
```

它将产生这种效果：

{{< admonition warning >}}
这是一个警告标记。
{{< /admonition>}}

可以使用的标记有以下 9 种：

- `attention` 
- `caution` 
- `error` 
- `hint` 
- `important` 
- `note` 
- `tip` 
- `warning` 


## 参考资料

1. wklchris. [reStructuredText 简介](https://self-contained.github.io/reStructuredText/index.html).

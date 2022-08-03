---
title: "使用代码片段编写 LaTeX 文档"
date: 2022-06-16T08:43:47+08:00
tags: ["LaTeX","代码片段"]
categories: ["LaTeX"]
draft: false
---

LaTeX 文档的源码有很多格式化语法，例如插图、表格等环境。使用代码片段可以很容易地插入这种结构化代码，加快文档的编写。本文介绍代码片段插件的使用方法，并介绍我自己的设计思路。

<!--more-->

## 插件介绍与使用

顾名思义，代码片段就是一小段可以重复利用的代码。使用代码片段本质上类似于复制粘贴并修改的操作，但利用关键字触发可以避免复制代码的过程；不仅如此，通过插件可以对设定的代码片段进行进一步操作，大大提高编程效率。

### 插件简介

对于 Vim 或者 NeoVim 用户，可以使用 [UltiSnips](https://github.com/SirVer/ultisnips)，我在之前的 [NeoVim 基本配置]({{< ref "/posts/life/neovim/index.md" >}}) 中简要介绍了其安装方法和基本用法；对于 VS Code 用户，可以使用 [HyperSnips](https://marketplace.visualstudio.com/items?itemName=draivin.hsnips) 插件。这两款插件之间的对比如下表所示：

| 项目     | UltiSnips                           | HyperSnips                            |
| :---     | :---                                | :---                                  |
| 文件路径 | `<vimroot>/UltiSnips/`              | _HyperSnips: Open Snippets Directory_ |
| 文件命名 | `<filetype>.snippets`               | `<filetype>.hsnips`                   |
| 刷新插件 | `:call UltiSnips#RefreshSnippets()` | _HyperSnips: Reload Snippets_         |
| 编程接口 | Python                              | JavaScript                            |
| 触发片段 | 自动触发或自定义快捷键              | 自动触发或 `<Tab>` 键                 |

其中，斜体表示该操作可以通过 VS Code 界面键入 `<Ctrl><Shift>p` 打开命令面板搜索得到。

### 基本语法

在编写代码片段时，两个插件具有非常相似的语法，基本结构如下：

```UltiSnips
snippet trigger "description" options
snippet body
endsnippet
```

`snippet` 和 `endsnippet` 是编写代码片段的关键字，标志着代码片段定义的开始和结尾（抱歉这里的代码暂时不支持高亮）。

`trigger` 是触发代码片段的关键字，当编写文档时输入关键字并满足 `options` 约束的触发条件后，将会展开代码片段。一般情况下，两个插件的 `trigger` 可以直接设置为任意字符，如 `fig`。如果需要使用正则表达式，UltiSnips 需要将 `trigger` 使用单引号或双引号括起来，并在 `options` 中加入 `r` 选项；HyperSnips 只需要将 `trigger` 使用反引号 `` ` `` 括起来即可。

`"description"` 是对当前代码片段功能的描述，需要使用引号括起。通常情况下该参数不是必须的，但是为了使用后面的 `options` 选项（对位置敏感），需要补充该简要说明。

`options` 是触发选项，即编辑时键入关键字后还应当满足触发条件才能够展开代码片段，可选项有：

- `w`：单词边界触发。这是默认的触发选项，当关键字两端不存在其他非空字符时可以触发代码片段；
- `b`：行首触发。当关键子出现在单独一行的行首时可以触发代码片段；
- `i`：单词内触发：只要出现关键字就可以触发代码片段；
- `r`：（只在 UltiSnips 中有该选项）启用正则表达式；
- `A`：自动展开。当关键字可以触发代码片段时自动展开，通常与其他选项结合使用。

`snippet body` 是自定义的代码片段，即触发关键字后展开的内容。代码片段内可以使用 `$` 和数字设置跳点，这样可以使用设置的快捷键快速跳转：UltiSnips 需要自行设置，见 [NeoVim 基本配置]({{< ref "/posts/life/neovim/index.md" >}})；VS Code 使用 `<Tab>` 键跳至下一个跳点，使用 `<Shift><Tab>` 跳到上一个跳点。特别地，`$0` 为最后一个跳点，跳至这里后无法再进行回跳。代码片段内的跳点可以进一步使用花括号和冒号设置默认值。


下面用一个例子进行解释（两个插件通用）：

```UltiSnips
snippet beg "begin an environment" bA
\begin{${1:document}}
	$0
\end{${1:document}}
endsnippet
```

该片段定义了触发关键字 `beg` 以开始一个新的 LaTeX 环境，`bA` 设置该代码片段当且仅当 `beg` 出现在行首时自动展开。展开后，原本输入的 `beg` 将被代码片段的内容替换，且 `\begin{}` 和 `\end{}` 花括号里的内容将默认填充为 `document` 并以高亮选中可供替换。按下跳转键后光标将进入环境内部，由于该位置为 `$0`，该代码片段使用结束。

### 依内容触发

除了使用 `options` 对代码片段的触发条件进行设置，两个插件还提供了 `context` 功能进一步限定代码片段的触发条件：在 `snippet` 前一行通过 `context` 调用 Python （或 JavaScript）函数，只有当该函数返回 `True` 时，后面的代码片段可以触发。利用这个功能，我们可以检测当前光标位置所处的环境，当处于数学环境中时才启用某些代码片段，以减少误触发的概率。

对于 Vim/NeoVim 用户，UltiSnips 在处理 LaTeX 文档时需要借用 [vimtex](https://github.com/lervag/vimtex) 插件提供的 `vimtex#syntax#in_mathzone()` 函数；而将其应用于 Markdown 时，还要进一步通过 [vim-markdown](https://github.com/preservim/vim-markdown) 插件使该能够判断 Markdown 文件的数学环境。如此做，在代码片段文件的开头做如下函数定义：

```UltiSnips
global !p
def math():
	return vim.eval('vimtex#syntax#in_mathzone()') == '1'
endglobal
```

然后在 `snippet` 的前一行加入 `context "math()"` 即可。

对于 VS Code 用户，可以使用 `<Ctrl><Shift>p` 打开命令面板，搜索使用 _Developer: Inspect Editor Tokens and Scopes_，通过 _scopes_ 属性查看当前光标所在的环境。相应地，HyperSnips 可以定义类似的 JavaScript 函数用于数学环境的判断：

```HyperSnips
global
function math(context){
    return context.scopes.some(s => s.includes(".math"));
}
endglobal
```

不同于 UltiSnips 的用法， HyperSnips 在 `snippet` 的前一行加入的命令为 `context math(context)`。


### 使用编程接口

如前所述，UltiSnips 和 HyperSnips 分别支持在代码片段内使用 Python 和 JavaScript 作为编程接口。这通常与正则表达式联合使用，可以更加灵活地处理代码片段。UltiSnips 中使用编程接口时，Python 代码需要使用 `` `!p`` 和 `` ` `` 包裹；而 HyperSnips 的 JavaScript 代码需要用 ` `` ` 在两端包裹。两个插件提供了默认变量用于接口，常用的变量如下表所示（ UltiSnips 提供更多变量，使用 `:h UltiSnips-python` 查看）

| 关键字内容                 | UltiSnips     | HyperSnips |
| :---                       | :---          | :---       |
| 当前文件路径               | `path`        | `path`     |
| 代码片段各跳点的内容       | `t`           | `t`        |
| 正则表达式各分组匹配的内容 | `match.group` | `m`        |
| 编程返回的代码片段         | `snip.rv`     | `rv`       |

由于本人对 JavaScript 所知甚少，下面用 Python 接口为例进行解释。

```UltiSnips
context "math()"
snippet '([A-Za-z]+)rm' "mathrm" rA
`!p snip.rv = '\\mathrm{' + match.group(1) + '}' `$0
endsnippet
```

该 UltiSnips 代码片段的第一行约束了该片段只在数学模式下生效。触发关键词使用引号，结合触发选项 `r` 说明使用了正则表达式：圆括号对字符串做了一个分组，匹配之后该分组的内容可以使用 `match.group(1)` 获取；分组内的中括号指明该分组匹配的内容为大小写字母，后面的加号表示至少有一个字母；圆括号外的字符表示该关键字必须以 `rm` 结尾（这就是所谓的“后缀式触发”）。该代码片段实现的效果是：在数学模式下，在字符后面加入 `rm` 可以将前面的字符变成 `\mathrm{}` 命令包围的直立字体。更多关于正则表达式的用法可以参考 [菜鸟教程](https://www.runoob.com/regexp/regexp-metachar.html) 等技术教程。


## 代码片段设计示例

为了偷懒，代码片段的关键字应当尽可能少，使用 2～3 个字符较为合理。并且根据 Elijan 的建议，尽可能使用自动展开加快编写速度。

为此，我定义了下列关键字用于触发 LaTeX 中的各种环境或命令：

| 关键字     | 功能                   | 触发条件 |
| :---       | :---                   | :---     |
| `env`      | 新建 LaTeX 环境        | 行首触发 |
| `beg`      | 新建 LaTeX 环境        | 行首触发 |
| `fig`      | 新建插图环境           | 行首触发 |
| `tabu`     | 新建普通表格           | 行首触发 |
| `tabx`     | 新建定宽表格           | 行首触发 |
| `tabl`     | 插入三线表的横线       | 行首触发 |
| `equ`      | 单行公式环境           | 行首触发 |
| `gat`      | 居中对齐的多行公式环境 | 行首触发 |
| `ali`      | 手动对齐的多行公式环境 | 行首触发 |
| `gad`      | 居中对齐公式的子环境   | 边界触发 |
| `ald`      | 手动对齐公式的子环境   | 边界触发 |
| `pmat`     | 圆括号包围的矩阵环境   | 边界触发 |
| `bmat`     | 方括号包围的矩阵环境   | 边界触发 |
| `Bmat`     | 花括号包围的矩阵环境   | 边界触发 |
| `vmat`     | 单竖线包围的矩阵环境   | 边界触发 |
| `Vmat`     | 双竖线包围的矩阵环境   | 边界触发 |
| `ff`       | 插入数学分式           | 边界触发 |
| `lr(`      | 自动大小的圆括号       | 边界触发 |
| `lr[`      | 自动大小的方括号       | 边界触发 |
| `lr{`      | 自动大小的花括号       | 边界触发 |
| `lr<`      | 自动大小的尖括号       | 边界触发 |
| `ab\|`     | 自动大小的绝对值符号   | 边界触发 |
| `no\|`     | 自动大小的范数符号     | 边界触发 |
| `b(`       | 手动大圆括号           | 边界触发 |
| `b2(`      | 手动更大的圆括号       | 边界触发 |
| `b3(`      | 手动超级大的圆括号     | 边界触发 |
| `b4(`      | 手动究极大的圆括号     | 边界触发 |


使用正则表达式结合词内触发可以实现更常用的后缀式触发，这在对数学符号进行修饰时非常好用。例如上面演示的触发正体命令。类似地，我做了如下定义（用 `X` 表示后缀前面的内容，不能出现空格）：

| 后缀  | 命令           | 说明                   |
| :---  | :---           | :---                   |
| `rm`  | `\mathrm{X}`   | 将变量变为直立体       |
| `bf`  | `\mathbf{X}`   | 将变量变为粗体         |
| `fk`  | `\mathfrak{X}` | 将变量变为哥特体       |
| `bm`  | `\bm{X}`       | 使用 `bm` 宏包加粗变量 |
| `ii`  | `X^{-1}`       | 求逆                   |
| `sr`  | `\sqrt{X}`     | 开方                   |
| `vec` | `\vec{X}`      | 箭头（矢量符号）       |
| `dot` | `\dot{X}`      | 一个点（一阶导数）     |
| `ddo` | `\ddot{X}`     | 两个点（二阶导数）     |
| `hat` | `\hat{X}`      | 尖帽子（估计值）       |
| `bar` | `\bar{X}`      | 横线（平均值）         |
| `bre` | `\breve{X}`    | 圆帽子（测量值）       |
| `til` | `\tilde{X}`    | 波浪线（误差）         |

使用后缀触发可以实现更加便利的功能：

- __分式自动处理__

1500 页数学笔记的小哥在他的 [博客](https://castel.dev/post/lecture-notes-1/) 中给出了自动处理分式的代码片段：在数学模式下，当输入除法 `/` 时，会自动将前面的字符作为 `\frac` 的分子，并跳转到分母位置。当分子不止一个变量时，可以使用圆括号括起后再输入 `/`，此时分子会自动取消最外围用于定界的圆括号。

- __角标自动处理__

数学通常会与角标打交道，为此，我在数学模式下定义了代码片段：`任意字符;下标;上标;` 。该代码片段在感受第三个封号后会自动处理角标，并且会根据字符长度选择性地添加 `{}`。下标或上标可以置空，但不允许出现空格。角标中处理特殊符号时可以使用空的花括号分隔命令，例如 `\omega{}t` 。


上面讨论的 UltiSnips 和 HyperSnips 代码片段可以分别在我 [nvim 仓库](https://github.com/iChunyu/nvim/tree/main/UltiSnips/tex) 和 [LaTeX 仓库](https://github.com/iChunyu/LearnLaTeX/tree/main/util) 找到，欢迎使用和分享建议。


## 参考资料

1. Gilles Castel. [How I'm able to take notes in mathematics lectures using LaTeX and Vim](https://castel.dev/post/lecture-notes-1/).
2. Elijan J. Mastnak. [An UltiSnips guide for LaTeX workflows](https://ejmastnak.github.io/tutorials/vim-latex/ultisnips.html).


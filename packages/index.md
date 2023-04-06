# LaTeX 常用宏包简介


基于 $\LaTeX$ 编写文档时，使用宏包不仅能够更方便地对文档格式进行调整，还可以方便正文的写作。本文分享部分常用宏包，旨在快速介绍其核心功能和一般用法。

<!--more-->

{{< admonition note>}}
本文介绍的宏包均收录于 [TeX Live](https://tug.org/texlive/)。若宏包用法更新，可以在命令行使用 `texdoc 宏包名` 查看已安装版本的帮助文档。

本文只介绍宏包最基本的一些设置和用法，详细说明请参考相应的帮助文档。
{{< /admonition >}}


```latex
% CTeX configuration
\ctexset{
    tocdepth = 2,
    appendix/name = 附录
}

% Date format yyyy-mm-dd
\usepackage{datetime2}

% Page margin
\usepackage{geometry}
\geometry{
    a4paper,
    top = 45mm,
    bottom = 28mm,
    left = 28mm,
    right = 28mm,
    headheight = 15mm,
    headsep = 6mm,
    footskip = 11mm
}


% Color and Google colors
\usepackage[hyperref]{xcolor}
% \definecolor{blue}{HTML}{4285F4}
% \definecolor{red}{HTML}{DB4437}
% \definecolor{yellow}{HTML}{F4B400}
% \definecolor{green}{HTML}{0F9D58}


% Footer and header of page
\usepackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\headrule}{\makebox[0pt][l]{\rule[0.6mm]{\textwidth}{0.3mm}}\rule{\textwidth}{0.3mm}}
\renewcommand{\footrule}{\rule{\textwidth}{0.3mm}}
% \renewcommand{\footrulewidth}{0.4pt}
\lhead{}
% \chead{\slshape\Large \makebox[120mm]{华\hfill{}中\hfill{}科\hfill{}技\hfill{}大\hfill{}学\hfill{}博\hfill{}士\hfill{}学\hfill{}位\hfill{}论\hfill{}文}}
\chead{\slshape\Large \makebox[60mm]{博\hfill{}士\hfill{}学\hfill{}位\hfill{}论\hfill{}文}}
\rhead{}
\cfoot{\thepage}


% add bibliography to TOC
\usepackage{tocbibind}


% Optimize footnotemark
\usepackage[perpage]{footmisc}              % clear count per page
\usepackage{pifont}                         % use number with ciecle
\renewcommand{\thefootnote}{\ding{\numexpr171+\value{footnote}}}


% Hyperlink
\usepackage{hyperref}                       % required package
\hypersetup{
    hidelinks,
    colorlinks = false,
    % pdfauthor = 肖春雨,
    bookmarksdepth = 3
}


% Math
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{nicematrix}
\usepackage{newtxmath}                      % times now roam font
\usepackage{bm}                             % bold fonts
\numberwithin{equation}{section}


% SI units
\usepackage{siunitx}
\sisetup{
    per-mode = symbol,
    uncertainty-mode = separate,
    range-phrase = \ensuremath{\,\sim\,},
    range-units = single
}


% Table and figure
\usepackage{graphicx}                       % figure package
\usepackage{tabularx}                       % fixed-width table
\usepackage{multirow}                       % merge row
\usepackage{booktabs}                       % standard three-line table
\usepackage{longtable}
\usepackage{caption}
\usepackage{subcaption}
\graphicspath{{./figures/}}
\numberwithin{figure}{section}
\numberwithin{table}{section}
\captionsetup{labelsep=space}


% Support user-defined styles of enumerate
\usepackage{enumitem}


% Biolography style
\usepackage{gbt7714}                        % China standard style
\bibliographystyle{gbt7714-numerical}       % numerical / author-year
\setlength{\bibsep}{0.5ex}                  % vertical spacing between references
\usepackage{notoccite}                      % remove citations in TOC and ensure correct numbering


% Cross reference
\usepackage[nameinlink]{cleveref}
\crefname{equation}{式}{式}
\crefname{table}{表}{表}
\crefname{figure}{图}{图}
\crefname{appendix}{附录}{附录}
\crefformat{section}{#2第~#1~章#3}
\crefformat{subsection}{#2第~#1~节#3}
\crefformat{subsubsection}{#2第~#1~小节#3}
\crefrangeformat{equation}{#3式~(#1)#4~\~{}~#5式~(#2)#6}
\captionsetup[subfigure]{subrefformat=simple,labelformat=simple}
\renewcommand\thesubfigure{\,(\alph{subfigure})}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define new environment and add to contents
\newenvironment{preface}[1]{\begin{center}
    \bfseries \large #1
\end{center}
\phantomsection     % required if using hyperref
\addcontentsline{toc}{section}{#1}
\normalsize \par}{}

% override `cleardoublepage', see `fancyhdr' doc
\makeatletter
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\begingroup
\mbox{}
\vspace*{\fill}
\begin{center}
（此页留白）
\end{center}
\vspace{\fill}
\thispagestyle{empty}
\newpage
\if@twocolumn\mbox{}\newpage\fi
\endgroup\fi\fi}
\makeatother

% support equations to display across pages 
\allowdisplaybreaks[4]
```

## 中文支持：`ctex`

$\text{C\TeX}$ 宏集为编写 $\LaTeX$ 文档提供了中文支持，其主要功能集中在 [`ctex`](https://www.ctan.org/pkg/ctex) 宏包及其相应的文档类（包括 `ctexart`、`ctexrep`、`ctexbook`、`ctexbeamer`）。在使用宏包和文档类时，常用的选项有：

- `zihao`：设置文档的默认字号，可选项有 `-4`（小四）、`5`（五号，默认值）；
- `linespread`：行间距的倍数，默认为 `1.3`；
- `fontset`：字库设置。Windows 用户通常不需要特别指定，Linux 用户通常需要安装额外字体，然后手动指定；
- `twoside`：设置文档双面排版，此时使用 `\cleardoublepage` 可以确保后面内容开始于奇数页。默认情况下使用的是 `oneside` 选项，`\cleardoublepage` 与 `\clearpage` 命令相同，开始新的一页。

除了宏包选项外，可以使用 `\ctexset` 命令进行额外的设置，常用选项包括：

- `tocdepth`：目录级别，例如对于 `ctexart` 文档类，将该参数设置为 `2` 时，生成的目录只包含 `section` 和 `subsection`；
- `today`：设置 `\today` 显示日期的格式，可选项有 `small`（阿拉伯数字现实日期）、`big`（全汉字日期）、`old`（英文格式的日期）；
- 标题名称汉化，常用设置及其默认值有：
    - `contentsname`：目录；
    - `listfigurename`：插图；
    - `listtablename`：表格；
    - `appendixname`：附录；
    - `bibname`：参考文献。


## 排版优化：`microtype`

如果你的文档由纯英文编写，简单地加载 [`microtype`](https://www.ctan.org/pkg/microtype) 宏包即可以实现排版细节的优化。


## 页面设置：`geometry`

[`geometry`](https://www.ctan.org/pkg/geometry) 宏包提供了 `\geometry` 命令可以方便地设置页面布局，常用设置包括：

- `paper`：指定纸张大小，例如 `a4paper`。使用时 `paper=a4paper` 可以直接简写为 `a4paper`；
- `top`、`bottom`、`left`、`right`：上、下、左、右的页面边距。


## 页眉页脚：`fancyhdr`

使用 [`fancyhdr`](https://www.ctan.org/pkg/fancyhdr) 宏包可以方便地对页眉、页脚进行设置。在使用 `\pagestyle{fancy}` 声明页面样式后，`\lhead`、`\chead`、`\rhead` 命令分别用于定义页眉左、中、右部分内容，将命令中的 “head” 改为 “foot” 可以相应地对页脚进行定义。

在定义页眉页脚时，可以使用 `\theXXX` 获取 `XXX` 相应的编号，例如 `\thepage` 是当前页码、`\thesection` 是当前节的编号。除此之外，`\leftmark` 可以读取当前节的标题。

特别地，对于双面文档，使用 `\cleardoublepage` 时，可以使用以下设置可以设置留白页面的内容。

```latex
% override `cleardoublepage', see `fancyhdr' doc
\makeatletter
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\begingroup
\mbox{}
\vspace*{\fill}
\begin{center}
（此页留白）
\end{center}
\vspace{\fill}
\thispagestyle{empty}
\newpage
\if@twocolumn\mbox{}\newpage\fi
\endgroup\fi\fi}
\makeatother
```


## 超链接：`hyperref`

[`hyperref`](https://www.ctan.org/pkg/hyperref) 扩展了生成的 PDF 文件的超链接功能，通常情况下简单地导入即可，除此之外，可以使用 `hypersetup` 命令进行个性化设置。例如，该宏包默认使用方框标记超链接，可以使用下面的设置将超链接用颜色标记：

```latex
\hypersetup{
    hidelinks,
    colorlinks = false
}
```

一般情况下，生成 PDF 文件导航目录（阅读器里面的导航，不是正文目录）的级别与 `ctex` 宏包的 `tocdepth` 参数设置一致，如果希望 PDF 文件的目录级别不同，可以使用该宏包参数 `bookmarksdepth` 进行修改。

{{< admonition note >}}
如果使用该宏包时出现问题，尝试在导言区中将该宏包最后导入。
{{< /admonition >}}


## 交叉引用：`cleveref`

[`cleveref`](https://www.ctan.org/pkg/cleveref) 宏包简化了交叉引用，使得所有类型的交叉引用都可以使用命令 `\cref` 完成，并且自动添加形如 “Section”、“Figure” 等前缀（对于英文写作，段落开头的交叉引用可以使用 `\Cref` 以确保首字母大写且不使用缩写）。

该宏包提供以下几个常用选项：

- `capitalise`：设置交叉引用前缀的首字母大写；
- `nameinlink`：默认情况只有交叉引用的数字可以进行超链接跳转，使用该选项后超链接包含前缀和后缀；
- `noabbrev`：设置交叉引用的前缀不使用缩写。

`\cref` 命令一次性可以接收多个标签，标签之间用逗号分割，例如 `\cref{fig:bodeplot,fig:stepplot}`。多个引用时，还可以使用 `\crefrange` 指定引用范围，例如 `\crefrange{eq:basic}{eq:conclusion}` 将产生形如 “式 (3) ~ 式 (14)”形式的引用。

英文写作时通常不需要对该宏包进行额外设置，对于中文文档，需要对前后缀进行设置，参考设置如下：

```latex
\crefname{equation}{式}{式}
\crefname{table}{表}{表}
\crefname{figure}{图}{图}
\crefname{appendix}{附录}{附录}
\crefformat{section}{#2第~#1~章#3}
\crefformat{subsection}{#2第~#1~节#3}
\crefformat{subsubsection}{#2第~#1~小节#3}
\crefrangeformat{equation}{#3式~(#1)#4~\~{}~#5式~(#2)#6}
```

## 列表设置：enumitem

[`enumitem`](https://www.ctan.org/pkg/enumitem) 提供了很多选项以优化列表环境，并可以使用 `\setlist` 进行全局设置。例如默认的列表之间间距太大，使用 `\setlist{nosep}` 取消额外间距。


## 国际单位制：`sinunitx`

[`siunitx`](https://www.ctan.org/pkg/siunitx) 宏包大大方便了带单位数值的编写，最常用的命令有：

- `\qty{数值}{单位}`：（老版本为 `\SI` 命令）其中数值可以采用程序的写法，例如 `3e-15` 将渲染为 {{< math >}}$3 \times 10^{-15}${{< /math >}}；单位部分可以直接采用该宏包定义的多种标准单位及其组合，例如 `\kilogram`、`\metre\per\second` 等。单位可以直接使用相应的英文字符，例如 `Hz`，在这种方法下，表示乘法关系的单位之家通常有一个小空格，为了确保单位正确渲染，应当添加 一个英文句点，例如力矩可以写作：`\qty{3.14e-3}{N.m}`。
- `\ang{数值}`：角度的表述可以单独使用该命令；
- `\num{数值}`：只渲染数值部分；
- `\unit{单位}`：只渲染单位部分；
- `\qtyrange{数值}{数值}{单位}`：设定某一范围内的数量。

数量的输出格式可以使用 `sisetup` 命令进行设置，参考示例如下：

```latex
\sisetup{
    per-mode = symbol,
    uncertainty-mode = separate,
    range-phrase = \ensuremath{\,\sim\,},
    range-units = single
}
```

特别地，改宏包提供了 `S` 列格式，可以在排版表格时将竖直在小数点对齐，然后整体向在列居中。


## 美丽的盒子：`tcolorbox`

[`tcolorbox`](https://www.ctan.org/pkg/tcolorbox) 宏包提供了 `tcolorbox` 环境 和 `\tcbox` 命令用于产生各种彩色的盒子。该宏包的功能非常强大，这里只展示一个简单的示例：论文修订时结合边注提醒审稿人修改内容，部分代码如下：


```latex
% 导言区定义 \Rev 命令，以边注的形式标记附近修订所对应的审稿意见
\newcommand\Rev[1]{}
\usepackage{marginnote}
\newcommand\Rev[1]{
    \marginnote{\tcbox[on line,
    arc=4pt,colback=blue!10!white,colframe=blue!50!black,
    boxrule=0.7pt,boxsep=0pt,left=3pt,right=3pt,top=3pt,bottom=3pt]{
    \small Rev. #1
}}}
```


## 跟踪修改：`changes`

[`changes`](https://www.ctan.org/pkg/changes) 宏包提供了标记修订的接口，可以生成带标记的 PDF 文档。其中常用命令包括：

- `\added{new}`：添加；
- `\deleted{old}`：删除；
- `\replaced{new}{old}`：替换；
- `\highlight{text}`：高亮；
- `\comment{text}`：备注。

在某些特别场景下，上述默认命令可能与其他宏包的命令冲突，可以在导入宏包时加入 `commandnameprefix` 选项，例如：

```latex
% 导入宏包并将命令增加 `ch` 前缀，例如：\added --> \chadded
\usepackage[commandnameprefix=always]{changes}
```

使用该宏包提供的 `final` 选项可以编译出“接受所有修订”之后的文档，可用于终稿的编译。

通常情况下手动标记修订是比较麻烦的，可以复制 $\LaTeX$ 源码后直接修订，然后使用 `latexdiff` 命令进行差异对比并自动生成带标记的文档。为了美化，将 `latexdiff` 输出的文件中的差异标记命令用 `changes` 宏包重载即可。


## 数学相关宏包

编写数学公式时，常用的宏包如下：

```latex
\usepackage{amsmath}
\usepackage{amssymb}
% \usepackage{nicematrix}
\usepackage{newtxmath}
\usepackage{bm}
\numberwithin{equation}{section}
```

[`amsmath`](https://www.ctan.org/pkg/amsmath) 提供了大量数学环境的支持；`amssymb` 提供了额外的数学符号；对于矩阵排版，如有特殊需求，可以使用 [`nicematrix`](https://www.ctan.org/pkg/nicematrix) 宏包提供的 `NiceArray` 等环境；[`newtxmath`](https://www.ctan.org/pkg/newtx) 宏包将数学字体设置为罗马形式的衬线体，可根据个人喜好选择性使用；[`bm`](https://www.ctan.org/pkg/bm) 宏包提供了 `\bm` 命令专门用于加粗数学符号。上述代码的最后一行将节编号加入到的公式编号中。


## 图表相关宏包

常用的图表相关宏包设置如下：

```latex
\usepackage{graphicx}                       % figure package
\usepackage{tabularx}                       % fixed-width table
\usepackage{multirow}                       % merge row
\usepackage{booktabs}                       % standard three-line table
\usepackage{longtable}
\usepackage{subcaption}
\usepackage{caption}
\graphicspath{{./figures/}}
\numberwithin{figure}{section}
\numberwithin{table}{section}
\captionsetup{labelsep=space}
```

[`graphicx`](https://www.ctan.org/pkg/graphicx) 宏包用于处理插图，其核心命令为 `\includegraphics[选项]{图的文件名}`，其中，选项主要用来调整图的缩放和旋转，常用参数有 `width`、`height`、`scale`、`angle`。此外，该宏包提供了 `\scalebox` 命令用于对盒子的大小进行缩放。为了在插入图片时省去文件路径，可以使用 `graphicspath` 命令声明搜索路径。

[`tabularx`](https://www.ctan.org/pkg/tabularx) 宏包提供了定宽表格 `tabularx` 环境，使用该环境时需要在列格式前声明表格总宽度。此外，该宏包提供了 `X` 列格式，用于自动调整列的宽度。

[`multirow`](https://www.ctan.org/pkg/multirow) 宏包提供的 `\multirow[竖直位置]{合并行数}{列宽}{内容}` 命令可以用于合并表格的行。其中，“竖直位置可以设置为 `c` 中间对齐（默认）、`t` 顶部对齐或 `b` 底部对齐；“列宽”可以设置为 `*` 以自动进行调整。

[`booktabs`](https://www.ctan.org/pkg/booktabs) 宏包提供了标准三线表定义，分别是 `\toprule`、`\midrule` 和 `\bottomrule`。特别地，使用 `\cmidrule` 命令可以只绘制部分列的中间横线。

当表格特别长时，可以使用 [`longtable`](https://www.ctan.org/pkg/longtable) 处理跨页表格，参考用法如下，此处不做展开。

```latex
\begin{longtable}{ll}
    \caption{表名}
    \label{tab:longtable}
    % 首页表头
    \\ \toprule
    \endfirsthead
    % 续页表头
    \multicolumn{2}{l}{（续表）} \\ \midrule
    \endhead
    % 前页表尾
    \midrule \multicolumn{2}{r}{（接下一页表格）} \\
    \endfoot
    % 末页表尾
    \bottomrule
    \endlastfoot
    % 表格内容
    XX & XX \\
    XX & XX \\
\end{longtable}
```

当需要图片并排时，可以使用 [`subcaption`](https://www.ctan.org/pkg/subcaption) 宏包提供的 `\subcaptionbox` 命令，例如：

```latex
\begin{figure}[!htb]
    \centering
    \subcaptionbox{图名A\label{fig:figA}}{\includegraphics[height=55mm]{图片1.pdf}}
    \hspace{10mm minus 5mm}
    \subcaptionbox{图名B\label{fig:figB}}{\includegraphics[height=55mm]{图片2.pdf}}
    \caption{总图名}
    \label{fig:figAB}
\end{figure}
```

使用 [`caption`](https://www.ctan.org/pkg/caption) 宏包对图表名称的格式进行设置，例如上面利用 `\captionsetup{labelsep=space}` 将图表编号与名字之间的间隔设置为了空格（其他的类似还有分号、句点等习惯）。

类似于公式的编号设置，可以使用 `\numberwithin` 将节的编号添加到图表编号中。


## 参考文献相关宏包

英文参考文献格式可以由 [`natbib`](https://www.ctan.org/pkg/natbib) 宏包手动设置，或使用期刊模板提供的样式。对于中文文献，一般使用 [`gbt7714`](https://www.ctan.org/pkg/gbt7714) 自动处理，为了使用数字编号，需要在使用该宏包后采用 `\bibliographystyle{gbt7714-numerical}` 指定格式。该宏包的默认样式基本可以满足要求，如果需要额外设置，可参考说明文档修改对应的 `.bst` 样式文件。

```latex
\usepackage{gbt7714}                        % China standard style
\bibliographystyle{gbt7714-numerical}       % numerical / author-year
\setlength{\bibsep}{0.5ex}                  % vertical spacing between references
\usepackage{notoccite}                      % remove citations in TOC and ensure correct numbering
```

如果在图表的名字中插入了参考文献，可以使用 [`notoccite`](https://www.ctan.org/pkg/notoccite) 宏包避免引用的编号出现在目录中。该宏包还进一步确保了图标标题插入引用时的编号正确。


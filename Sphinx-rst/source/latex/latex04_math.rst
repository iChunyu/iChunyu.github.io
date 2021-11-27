数学公式
==========================================

对于理工科类的报告或论文，除了图表以外，还经常使用到各种公式。 LaTeX 对数学公式提供了非常好的支持，本文只对几种常用的数学环境进行介绍。


数学模式简介
------------------------------------------

与一般的正文不同，数学会涉及到大量的符号，且对字体、间距有明确的要求。因此需要使用数学模式。 TeX 有两种数学模式：行内（inline）模式和显示（display）模式。前者一般与正文交叉，出现在正文之中，例如这个公式 :math:`\sin 2x=2\sin x \cos x` ；反之常用显示模式在单独一行中以合适的间距显示出来，如下式所示

.. math::

    \begin{aligned}
    \cos 2x &= \cos^2x - \sin^2 x \\
    &= 2\cos^2x - 1 \\
    &= 1-2\sin^2 x
    \end{aligned}

行内公式的使用相对简单，只需要用 ``$`` 将公式括起来即可，例如上面示例中的代码为： ``\sin 2x = 2\sin x \cos x$`` 。

看到这些 LaTeX 的数学公式代码请不要慌张，因为这一般不是关注的重点，有很多软件可以辅助生成，例如 `Mathtype` 、 `Mathpix Snip <https://mathpix.com/>`_ 。不过，我自己偶尔会用一些在线的代码生成工具，友情推荐下 `妈叔在线公式编辑器 <https://www.latexlive.com/>`_ 。

对于显示模式，常采用不同的数学环境，下面就常用的一些进行介绍。

.. hint::
    数学公式的排版通常离不开 AMS 宏包，本文的讨论都假设已在导言区使用宏包： amsmath 和 amssymb。


常用数学环境
------------------------------------------

作为一个初步的教程，本文不打算对 LaTeX 的博大精深展开太多介绍，仅对下面列举的常用环境进行介绍。

======================== ================================
环境                     简单说明
======================== ================================
``euqation``             单行公式居中显示
``gather``, ``gathered`` 多行公式居中显示
``align``, ``aligned``   多行公式整体居中，自定义对齐位置
======================== ================================

``equation`` 环境提供了单行公式的展示，更一般地常用 ``\[`` 和 ``\]`` 对进行简化，例如

.. code:: tex

    \begin{equation}
        \cos 2x &= \cos^2x - \sin^2 x
    \end{equation}

也等价于

.. code:: tex

    \[
        \cos 2x &= \cos^2x - \sin^2 x
    \]

该环境默认给公式进行编号，若要取消编号，可使用 ``equation*`` 环境，或者在不需要编号的公式后加上 ``\notag`` 命令。此外，默认的编号都是从 :math:`1` 开始计数，如果需要带上章节号，可以在导言区进行如下设置：

.. code:: tex

    % 导言区，设置公式编号包含节编号
    \numberwithin{equation}{section}

``equation`` 环境只能展示单行公式，为了展示多行公式，可采用 ``gather`` 环境，并用 ``\\`` 进行换行，例如

.. code:: tex

    \begin{gather}
        \cos 2x = \cos^2x - \sin^2 x \\
        = 2\cos^2x - 1 \\
        = 1-2\sin^2 x
    \end{gather}

.. figure:: figures/latex04a.png
    :figwidth: 90%
    :align: center

.. note::

    这个图片是我随手截取的，可能没有截取到正确的页面宽度，导致公式看上去没有在背景的中间，但是请相信我它确实在页面中间！

这种排版存在的第一个问题是：整个公式希望它共用一个编号，但它每一行都有一个编号。为此，可以嵌套 ``gathered`` 环境，将整个公式组合成“块”，作为一个整体进行排版。如：

.. code:: tex

    \begin{equation}
        \begin{gathered}
            \cos 2x = \cos^2x - \sin^2 x \\
            = 2\cos^2x - 1 \\
            = 1-2\sin^2 x
        \end{gathered}
    \end{equation}

.. figure:: figures/latex04b.png
    :figwidth: 90%
    :align: center

注意到， ``gathered`` 环境仅用于将公式组合成块，它的外部通常还需要嵌套其他的环境。由于单个块可以看作单行公式，所以可以在最外层使用 ``equation`` 环境。

同样，如果不希望 ``gather`` 产生任何编号，只要加上星号改为 ``gather*`` 环境即可。

``gather`` 的第二个问题是：多行公式的每行都是居中对齐的，而对于上面例子的推导而言，显然更好的方式是在等号处对齐，这就需要采用 ``align`` 环境。 ``align`` 在使用 ``\\`` 换行的基础上，还需要使用 ``&`` 指定对齐位置，并且整个公式块将在行内居中显示。例如

.. code:: tex

    \begin{align}
        \cos 2x &= \cos^2x - \sin^2 x \\
        &= 2\cos^2x - 1 \\
        &= 1-2\sin^2 x
    \end{align}

.. figure:: figures/latex04c.png
    :figwidth: 90%
    :align: center

这时，我们可以看到公式整体处于居中，而公式内部在等号位置对齐。同样，为了避免每行出现编号，使用 ``aligned`` 环境将公式转化为块即可，如

.. code:: tex

    \begin{align}
        \begin{aligned}
            \cos 2x &= \cos^2x - \sin^2 x \\
            &= 2\cos^2x - 1 \\
            &= 1-2\sin^2 x
        \end{aligned}
    \end{align}

.. figure:: figures/latex04d.png
    :figwidth: 90%
    :align: center

喏，相信看到这里，大家可能会想：既然单行公式是多行公式的特殊情况，那么只需要记住多行公式排版即可，而多行公式多数需要指定对齐位置，那索性只记下 ``align`` 环境就行了。幸运的是，就我个人的经验来看，事实确实如此。除非特别地要求多行公式分别居中，不得不用到 ``gather`` 环境，一般情况下 ``align`` 及其变种 ``aligned`` 足够应付绝大多数排版要求。


矩阵排版
------------------------------------------

基本的 LaTeX 中，矩阵采用 ``\matrix`` 等命令进行排版，由于其语法与 LaTeX 基本语法不一致，常采用 AMS 提供的一系列矩阵环境来代替，这些环境的使用与表格的使用相同，区别仅仅在于外部的括号不同：

=========== ========
环境        简单说明
=========== ========
``matrix``  无括号
``pmatrix`` 圆括号
``bmatrix`` 方括号
``Bmatrix`` 花括号
``vmatrix`` 单竖线
``Vmatrix`` 双竖线
=========== ========

这里只给出一个例子：

.. code:: tex

    \begin{align}
        \begin{vmatrix}
            a & b \ c & d
        \end{vmatrix}
        = ad-bc
    \end{align}

.. figure:: figures/latex04e.png
    :figwidth: 90%
    :align: center

矩阵排版更灵活的方法是采用 ``array`` 环境，有需求的小伙伴可以查看其宏包说明。


.. hint::

    数学排版从操作上并非难事，但有很多细节问题需要大家认真考虑。比如，标准的数学采用斜体作为标量的字体，加粗的字体表示矩阵或者向量，那么，自然对数的底 ``e`` 应当是什么字体？以及，微分运算符 ``d`` 呢？细心的朋友们会发现，常数和运算符都采用正体，并且运算符与变量之间的间距往往与变量之间的间距还略有不同。类似的细节还很多，算是行业标准，还望大家多多重视（恕我无能为力详细说明）。

.. 
   Converted from ``Markdown`` to ``reStructuredText`` using pandoc
   Last edited by iChunyu on 2021-04-25
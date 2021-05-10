自动化引用
==========================================


写文档的时候会在必要位置插入脚注进行补充说明，也会引用已经出现的图、表、章节等，即交叉引用。对于科技论文写作，会进一步涉及到参考文献引用；少数情况下，还会使用到外部超链接。被引对象的编号问题无疑是手动引用的繁琐之处，这篇文章向大家展示如何在 LaTeX 中实现自动化引用。




脚注
------------------------------------------


在 LaTeX 中可以轻松使用 ``\footnote{<text>}`` 命令快速插入脚注，也可以用 ``\footnotemark`` 打上标记，在其后相应的位置使用 ``\footnotetext{<text>}`` 给出具体脚注信息。这两种方法在正文中使用时并无二异，但是如果在表格等环境中使用脚注时， ``\footnote{<text>}`` 通常会失效，这时应当使用 ``\footnotemark`` 打上标记，然后在环境外使用 ``\footnotetext{<text>}`` 给出具体脚注内容。


.. note::

    为了详细展示命令的使用方法，这里用尖括号和被尖括号包围的文字表示示例，若无特殊说明，实际使用命令时不带尖括号。


``\footnotemark`` 和 ``\footnotetext{<text>}`` 成对出现，并且能够自定义编号，这通过使用中括号给出的可选参数进行设置，例如下面的例子：


.. code-block:: LaTeX

    这是第一个脚注 \footnotemark[1]，这是第二个 \footnotemark[2]。

    \footnotetext[1]{脚注1的内容}
    \footnotetext[2]{脚注1的内容}


脚注默认的样式是阿拉伯数字角标，而对于中文文档的习惯，通常需要用带圆圈的数字且每页重新计数，这可以在导言区进行如下设置：


.. code-block:: LaTeX

    % 优化脚注设置
    \usepackage[perpage]{footmisc}              % 每页重新计数
    \usepackage{pifont}                         % 设置带圆圈的数字
    \renewcommand{\thefootnote}{\ding{\numexpr171+\value{footnote}}}




超链接
------------------------------------------

超链接的使用相对容易，只需要导入 ``hyperref`` 宏包即可，配合 ``\href{<link>}{<text>}`` 命令使用即可。例如我想产生一个像这样指向 `我的博客 <https://ichunyu.readthedocs.io/zh_CN/latest/>`_ 的超链接，只需要像这样编写文档即可：


.. code-block:: LaTeX

    像这样就可以产生一个指向 \href{https://ichunyu.readthedocs.io/zh_CN/latest/}{我的博客} 的超链接。


导入 ``hyperref`` 宏包的另一个好处就是生成的文档会根据章节自动生成标签链接，方便 PDF 文档的导航。


默认情况下，不同类型的超链接将以不同颜色的方框将链接内容包围，即使这个方框在打印的时候不会出现，依然导致电子文档阅读时不够美观。所以我自己在使用的时候通常会在调用宏包后增加以下设置，将超链接的方框隐藏，使用带颜色的字来表示。


.. code-block:: LaTeX

    \hypersetup{hidelinks}              % 隐藏超链接的方框
    \hypersetup{colorlinks = true}      % 使用颜色字体表示超链接


当然，如果不喜欢默认的颜色，也可以进行设置，这就不多说了。




交叉引用
------------------------------------------


交叉引用的一般思路是在适当的位置使用 ``\label{<label>}`` 插入标签，然后在需要引用的地方使用 ``\ref{<label>}`` 引用其编号，或者也可以使用 ``\pageref{<label>}`` 引用对象所在的页码。这就好比 LOL 里边先插眼后 TP 一样。下面给出一些可供参考的标签插入：


.. code-block:: LaTeX

    
    \section{自动化交叉引用}  
    \label{sec:autocite}                    % 章节标签

    \begin{figure}[!htb]
        \centering
        \includegraphics[width=0.8\textwidth]{demo-figure.pdf}
        \caption{figure name}
        \label{fig:demo}
    \end{figure}                            % 图片标签

    \begin{table}[!htb]
        \centering
        \caption{table name}
        \label{tab:demo}                    % 表格标签
        \begin{tabular}
            <...>
        \end{tabular}
    \end{table}                    

    \begin{equation}
        \sin 2x = 2 \sin x \cos x
        \label{tab:demo}                    % 公式标签
    \end{equation}      


在引用编号的时候，对于图、表、章节通常可以直接引用，而公式编号通常用括号包围。为此， AMS 数学红包提供了 ``\eqref{<label>}`` 命令在引用公式是为编号加上括号。此外，以英文引用表格为例，“Tab” 和数字之间会有一个空格，且换行不能在 “Tab” 和数字之间打断，因此需要用 ``~`` 产生不可打断的空格，完整的引用示例应当像这样： ``Tab~\ref{tab:demo}`` 。


为了使引用更加简单，推荐使用 ``cleveref`` 宏包提供的 ``\cref{<label>}`` ，它会根据计数器类型自动添加 “Tab”、“Fig” 等前缀，对于公式也能自动添加括号，使用非常地方便。由于该宏包依赖于 ``hyperref`` ，因此建议在导言区最后引入。同时该宏包提供以下选项：

- ``capitalise`` ：宏包默认前缀小写，导入该选项后前缀首字母大写；
- ``nameinlink`` ：一般交叉引用的超链接仅为编号，导入该选项后名字也在超链接范围内；
- ``noabbrev`` ：宏包默认采用缩写，导入该选项后将变为全称。


.. hint::

    实际上 ``cleveref`` 还提供了 ``\Cref{<label>}`` 命令，当需要在句子的开头引用时应当使用该命令以确保首字母大写，其他功能与 ``\cref{<label>}`` 一致。



如果想自定义 ``\cref{<label>}`` 的前缀，可以使用 ``\crefname{<type>}{<singular>}{<plural>}`` 进行定义，三个参数分别是计数器类型、单数形式前缀、复数形式前缀。进一步，还可以使用 ``\crefformat{<type>}{<format>}`` 对格式进行详细修改，其中 ``<format>`` 应当包括 ``#1`` 、 ``#2`` 、 ``#3`` 三个输入参数，它们分别是计数器的计数和编号左右的符号（如数学编号的括号），通常可以不管。例如我自己用以下设置对 ``\cref{<label>}`` 进行汉化：


.. code-block:: LaTeX

    \crefname{equation}{式}{式}
    \crefname{table}{表}{表}
    \crefname{figure}{图}{图}
    \crefformat{section}{\!第~#2#1#3~节\!}                  % 使用 \! 取消命令前后的空格
    \crefformat{subsection}{\!第~#2#1#3~小节\!}




文献引用
------------------------------------------

以前使用 Word 的时候最头疼的就是参考文献引用及其格式设置，而对于 LaTeX 而言，这是十分简单的工作。对于投期刊文章的小伙伴，一般期刊会给 LaTeX 模板并内置了参考文献样式；对于普通中文论文，一般需要满足 GB/T 7714—2015 《信息与文献
参考文献著录规则》，而 ``gbt7714`` 宏包为此提供了极大的便利。


参考文献的引用可以分为以下三步

#. 导言区导入 ``gbt7714`` 宏包并使用 ``\bibliographystyle{gbt7714-numerical}`` 设置为顺序编码制（也可以设置为 ``gbt7714-author-year`` ）；
#. 将参考文献导出为 ``.bib`` 文件，并在正文中使用 ``\cite{<citekey>`` 的形式引用；
#. 在需要插入参考文献列表的地方使用 ``\bibliography{<bibfilename>}`` 即可。


这里再稍微啰嗦一下文献的 ``.bib`` 文件，这一般可以通过文献管理软件导出，也可以从图书馆等文献查阅的网站导出。单个文件可以包含多个题注，任意题注具有类似以下的信息：


.. code-block:: LaTeX

    @book{canutoSpacecraftDynamicsControl2018,
    title = {Spacecraft Dynamics and Control: The Embedded Model Control Approach},
    author = {Canuto, Enrico and Novara, Carlo and Carlucci, Donato and Montenegro, Carlos Perez and Massotti, Luca},
    year = {2018},
    month = mar,
    publisher = {Butterworth-Heinemann},
    isbn = {978-0-08-100700-6},
    language = {en}
    }


这个文件通常都是导出的，基本不需要自己手动编写，而内容基本也可以顾名思义。引用该文献需要用到的 ``citekey`` 就是第一行花括号右侧的字符串，本例就是 ``canutoSpacecraftDynamicsControl2018`` 。
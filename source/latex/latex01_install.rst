安装与配置
==========================================

LaTeX 是一款开源排版软件，区别于Word的所见即所得，使用 LaTeX 编写文档更像是编写代码，需要经过编译才能生成 pdf 格式的文档。初学者可能会止步于这种代码式的文档编写方法，但随着使用的熟练，在科技报告、论文方面，其至少在下面几个方面碾压 Word ：

-  数学公式支持：  LaTeX 天然支持数学公式，而 Word 内置的公式编辑器一般不好用，通常需借助软件 Mathtype ；
-  文献引用支持：  LaTeX 天然支持文献引用，并提供了常见各种期刊标准样式，而 Word 内置的参考文献录入麻烦，常需借助文献管理软件如 `Zotero <https://www.zotero.org/>`_ 、`Endnote <https://endnote.com/>`_ 等；
-  快速模板切换：  LaTeX 仅需要对导言区的样式进行更改即可实现全文格式的变更，而 Word 则需要重新定义大量样式。

那么话不多说，开整。


安装
----------------------------------------

LaTeX 有很多发行版，TeX Live 是最为推荐的一款。下载只需要打开 `清华大学开源镜像站 <https://mirrors.tuna.tsinghua.edu.cn/>`_ ，在目录中查找 ``CTAN → TeX Live → Images`` ，选择任意 ``texlive*.iso`` 下载即可。

无论是 Linux 用户还是 Windows 用户，TeX Live 的安装绝对不是一件难事：

   安装脚本叫 install-tl，它在目录树的顶层。你可以通过 ``perl install-tl`` 来调用它。在 Windows 下，你可以运行在它旁边的批处理文件： ``install-tl-windows.bat`` 。

对于Linux用户，安装完成后还需要对路径进行设置，需要在 ``~/.bashrc`` 文件中添加以下内容（注意 TeX Live 版本号可能存在差异）

.. code:: bash

    export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:${MANPATH}
    export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:${INFOPATH}
    export PATH=/usr/local/texlive/2020/bin/x86_64-linux:${PATH}
    

至此安装完成，为了验证安装的正确性，Linux用户可以打开终端，Windows用户可以打开CMD，运行

.. code:: bash

   latex --version

正常输出版本号即代表  LaTeX 安装正确。

配置
----------------------------------------

如本文开头所示，使用 LaTeX 编写文档更像是编写程序，为此，我们还需要一个友好的编写代码环境（当然，你完全可以用记事本之类的软件，取决于个人爱好）。比如可以使用 `TeXstudio <texstudio.sourceforge.net/>`_ 作为编辑器，这款软件对新手非常友好，基本上不需要进行特别的配置。对于我们需要编写中文文档的，只需要将编译器改为 ``xelatex`` 即可。

另一个好看的编辑器莫过于 VS Code 了，我们仅需要安装插件 ``LaTeX Workshop`` ，并在设置中引入如下配置即可：

.. code:: json

   "latex-workshop.view.pdf.viewer": "tab",
   "latex-workshop.latex.tools": [
       {
           "name": "xelatex",
           "command": "xelatex",
           "args": [
               "-synctex=1",
               "-interaction=nonstopmode",
               "-file-line-error",
               "%DOCFILE%"
           ]
       },
       {
           "name": "pdflatex",
           "command": "pdflatex",
           "args": [
               "-synctex=1",
               "-interaction=nonstopmode",
               "-file-line-error",
               "%DOCFILE%"
           ]
       },
       {
           "name": "bibtex",
           "command": "bibtex",
           "args": [
               "%DOCFILE%"
           ]
       }
   ],
   "latex-workshop.latex.recipes": [
       {
           "name": "xelatex",
           "tools": [
               "xelatex"
           ],
       },
       {
           "name": "pdflatex",
           "tools": [
               "pdflatex"
           ]
       },
       {
           "name": "xe->bib->xe->xe",
           "tools": [
               "xelatex",
               "bibtex",
               "xelatex",
               "xelatex"
           ]
       },
       {
           "name": "pdf->bib->pdf->pdf",
           "tools": [
               "pdflatex",
               "bibtex",
               "pdflatex",
               "pdflatex"
           ]
       }
   ],
   "latex-workshop.bibtex-format.tab": "4 spaces",
   "latex-workshop.latex.autoBuild.run" : "never"




Hello World
----------------------------------------

配置好了就来一个最小示例吧。LaTeX 的文档以 ``.tex`` 为后缀，因此我们可以创建一个名为``HelloWorld.tex`` 文件，填入以下内容：

.. code:: tex

   % ====================================================
   % 🎆🎆🎆🎆🎆             导言区             🎆🎆🎆🎆🎆
   % ====================================================
   \documentclass{article}         % 业界习惯：百分号是注释开始的标志

   \title{Greetings}               % 不服就试：注释是不会进入正文的哟
   \author{SpringMan}              % 凑个对齐：在注释里可以任意地耍赖
   \date{\today}                   % 如你所见：导言区就是进行“某些”设置的


   % ====================================================
   % 🎆🎆🎆🎆🎆             正文区             🎆🎆🎆🎆🎆
   % ====================================================

   \begin{document}                % 可想而知：正文从这里开始
       \maketitle                  % 显而易见：这个命令用来产生标题

       Hello World !               % 打个招呼：你好世界
   \end{document}                  % 不难预料：正文在这里结束

使用 TeXstudio 的小伙伴可以点击“运行并查看”，使用 VS Code 的小伙伴可以仅使用 ``xelatex`` 编译，喜欢命令行的猛士也可以在当前目录下运行命令 ``xelatex HelloWorld.tex`` ，最后，我们打开编译生成的同名 pdf 文件，就可以看到以下效果，是不是非常神奇呢？

.. figure:: figures/latex01.png
    :figwidth: 90%
    :align: center


.. 
   Converted from ``Markdown`` to ``reStructuredText`` using pandoc
   Last edited by iChunyu on 2021-04-11
每日小技巧
==========================================

每天更新一个小技巧（也许吧）。


Inkscape 批量导出图片
------------------------------------------

之前用 Inkscape 画了很多矢量图，今天想把它们转成位图，一个一个打开再导出太麻烦了，于是想到 Inkscape 的命令行操作，果然有这个命令。结合 Python，可以轻松实现批量导出：

.. code-block:: Python

    import os

    files = os.listdir()
    for file in files:
        # 图片之前另存了 PDF，以此为例
        if os.path.splitext(file)[-1] == '.pdf':
            bash_command = 'inkscape ' + file.replace(' ',r'\ ') + ' --export-type=png --export-dpi=600'
            os.system(bash_command)
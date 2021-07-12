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



Linux 查看 USB 接口
------------------------------------------

只需要在命令行运行 ``lsusb`` 即可。


Linux 测试 U 盘读写速度
------------------------------------------

最简单的方法就是实测，使用 ``dd`` 命令随机写入数据并读取，测试速度。这里需要用到两个特殊的设备

- ``/dev/zero`` ：文件“白洞”，产生任意大小的随机文件；
- ``/dev/null`` ：文件“黑洞”，所有写入的内容都被忽略。

使用 ``df -h`` 可以发现我的 U 盘挂载在 ``/run/media/xiaocy/misaka`` ，于是可以用下面的命令进行测试：

.. code-block:: bash

    # 测试写入
    time dd if=/dev/zero of=/run/media/xiaocy/xiaocy/test.tmp bs=4k count=100000

    # 测试读取
    time dd if=/run/media/xiaocy/xiaocy/test.tmp of=/dev/null bs=4k
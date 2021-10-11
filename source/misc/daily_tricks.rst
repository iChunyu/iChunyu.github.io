日常小技巧
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


CSGO 绑定跳投
------------------------------------------

在 CSGO 文件夹 ``<CSGO-root-path>/csgo/cfg/`` 内新建 ``keybind.cfg`` 文件，并输入以下内容

.. code-block::

    alias +jumpthrow"+jump;-attack;-attack2";
    alias -jumpthrow -jump;
    bind t +jumpthrow; 


每次运行 CSGO 时，按 ``~`` 键打开控制台，执行 ``exec keybind`` 即可。使用跳投时先点鼠标左键，然后按 ``t`` 即可。

.. note::

    控制台执行的命令 ``keybind`` 即为创建的 ``.cfg`` 文件名，可根据自己喜好修改；绑定的跳投键为上述代码第三行的第二个参数，也可以自行修改。


Vim 中文输入法问题
------------------------------------------

当使用 Vim 编辑中文文本时，在切换插入模式和普通模式时需要频繁切换输入法，为此可以使用 `fcitx.vim <https://github.com/lilydjwg/fcitx.vim>`_ 插件自动化解决这个问题。

对于 Manjaro 系统，也可以从 AUR 中一键安装该插件： ``yay -S vim-fcitx`` 。在命令行使用时，切换模式会存在延时，进一步可以在 ``~/.vimrc`` 配置文件中引入 ``set ttimeoutlen=100`` 而将其设置为较小值。

Linux 终端补全忽略大小写
------------------------------------------

在家目录下创建 ``.inputrc`` 并写入：

.. code-block:: text

    set completion-ignore-case on

然后重启终端即可。


VSCodeVim 配置
------------------------------------------

为了自动切换中英文输入法，在配置文件中添加以下设置（适用于 ``fcitx5`` 框架）：

.. code-block:: text

    "vim.autoSwitchInputMethod.enable": true,
    "vim.autoSwitchInputMethod.defaultIM": "1",
    "vim.autoSwitchInputMethod.obtainIMCmd": "/usr/bin/fcitx5-remote",
    "vim.autoSwitchInputMethod.switchIMCmd": "/usr/bin/fcitx5-remote -t {im}",


添加以下配置可以重新将 ``j`` 和 ``k`` 映射为 ``gj`` 和 ``gk`` ：

.. code-block:: text 

    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": ["j"],
            "after": ["g", "j"]
        },
        {
            "before": ["k"],
            "after": ["g", "k"]
        }
    ]


Linux 解压时中文乱码
------------------------------------------

使用附带 ``-O cp936`` 选项的 ``unzip`` 命令即可。需要注意，某些发行版的 ``unzip`` 不提供 ``-O`` 选项，需要安装 ``unzip-iconv`` 。

解压示例：

.. code-block:: bash
    
    unzip -O cp936 中文解压包.zip



Linux 增加 Swap 分区大小
------------------------------------------

使用 Linux 做计算时如果内存不够用，可以使用 Swap 空间将部分硬盘当作内存使用。如果 Swap 空间不够，可以使用以下方法进行扩容（需要管理员权限运行）：

#. 查看当前 Swap 空间大小： ``free``
#. 创建空文件用做 Swap 空间： ``sudo dd if=/dev/zero of=/swapfile bs=1M count=4096`` （创建了 4 GB 空间）
#. 将上一部创建的文件指定为 Swap 空间： ``sudo mkswap /swapfile`` 
#. 启用交换空间： ``sudo swapon /swapfile``
#. 查看当前 Swap 空间大小： ``free`` 

以上方法用于临时性地扩容，如果想要永久设置，设置 ``swapfile`` 开机时自动挂载即可：编辑 ``/etc/fstab`` ，在最后一行加入：

.. code-block:: text

    /swapfile           swap        swap        0   0



Linux 定时任务
------------------------------------------

定时任务可以使用 ``crontab`` 实现，常用的命令有：


.. code-block:: bash

    crontab -l          # 查看定时任务
    crontab -e          # 编辑定时任务
    crontab -r          # 删除所有任务


新建定时任务只需要按时间加命令的形式给出，由空格进行分割，其中时间由五个数字构成，分别是：分、时、日、月、周，并支持以下操作符

- ``*`` --- 所有可行取值
- ``/`` --- 指定重复周期
- ``-`` --- 指定时间范围
- ``,`` --- 离散时间序列


例如：

.. code-block:: text

    * * * * * myTask                            # 每分钟运行一次 myTask
    0 * * * * myTask                            # 每小时整点运行一次 myTask
    30 8 * * 1-5 myTask                         # 每周一到周五的 8:30 运行 myTask
    0 7-21/3 * * * myTask                       # 7 点到 21 点每 3 小时运行一次 myTask


.. note::

    为了确保定时任务生效，还需要启动相应的服务。在 manjaro 系统中，使用 ``sudo systemctl start cronie.service`` 可以开启服务，相应的将 ``start`` 选项改为 ``enable`` 可以设置自动启动； ``stop`` 可以关闭服务， ``status`` 查看当前服务状态。

.. 20 * * * * export DISPLAY=:0 && python pythontest.py
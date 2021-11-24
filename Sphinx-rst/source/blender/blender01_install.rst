（01）安装与配置
==========================================


安装
------------------------------------------

Manjaro Linux 使用以下命令即可一键安装：

.. code-block:: bash

    sudo pacman -S blender


.. note::

    抱着偷懒并且不容易出错的心态，不进行汉化设置，后续配置中也将用英文关键字进行介绍。



配置
------------------------------------------

打开首选项设置 ``Edit -> Preferences`` ：

- ``Input -> Keyboard -> Emulate Numpad`` --- 启用小键盘数字键；
- ``Navigation -> Orbit & Pan -> Orbit Around Selection`` --- 视角围绕所选物体进行旋转；
- ``Navigation -> Orbit & Pan -> Auto Depth`` --- 打开自动深度以避免视角卡死；
- ``System -> Cycles Render Devices -> CUDA`` --- 选择渲染的通用计算单元；
- ``System -> Menmory & Limits -> Global Undo`` --- 勾选全局撤销功能；
- ``Save & Load -> Auto Run Python Scripts`` --- 勾选自动运行 Python 脚本。
  

然后开启官方插件：打开 ``Edit -> Preferences -> Add-ons`` ，搜索并安装以下插件：

- ``Node: Node Wrangler``
- ``Rigging: Rigify``
- ``Import-Export: Import Images as Planes``
- ``Add Curve: Extra Objects``
- ``Add Mesh: A.N.T.Landscape``
- ``Add Mesh: BoltFactory``
- ``Add Mesh: Extra Objects``
- ``Interface: Copy Attributes Menu``
- ``Interface: Modifier Tools``
- ``Mesh: LoopTools``
- ``Object: Bool Tool``
- ``Render: Auto Tile Size``
- ``UV: Magic UV``


选择左下角的三道杠 ``Sace Preferences`` 即可。
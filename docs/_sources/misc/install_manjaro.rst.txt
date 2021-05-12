Manjaro 安装记录
===========================================


早就听闻过 Linux 的大名，一直想装一个玩一玩。折腾过 Debian 系列的 `deepin <https://www.deepin.org/>`_ 、`Ubuntu <https://ubuntu.com/>`_ 和它的衍生版 `Pop!_OS <https://pop.system76.com/>`_ ，都被各种各样的问题劝退，一度重新装回 Windows。直到某次看到有人安利 Arch 系的 `Manjaro <https://manjaro.org/>`_ ，抱着最后试一试的心态装上，没想到一直沿用至今。对我自己来说，Manjaro 无疑是最省事省心的 Linux 发行版了，将其安装过程记录于此。


-----


安装系统
------------------------------------------

Manjaro 的系统镜像可以从官网下载，为了提高下载速度，可以从国内镜像站下载，例如我自己常用的 `清华大学开源软件镜像站 <https://mirrors.tuna.tsinghua.edu.cn/>`_ 。Manjaro 有 XFCE、KDE、GNOME 三种官方桌面可供选择，而社区提供更多其他桌面环境。我自己使用的是 KDE 版本。

准备一个空U盘制作系统启动盘，Windows 用户可以使用 `Rufus <https://rufus.ie/>`_ 等工具通过用户界面对镜像文件进行烧写，对于 Linux 用户，可以按如下方式使用 ``dd`` 命令：

.. code-block:: bash

    sudo dd bs=4M if=[/path/to/manjaro.iso] of=/dev/sd[drive letter] status=progress oflag=sync


命令中的 ``if`` 和 ``of`` 分别代表输入文件（input file）和输出文件（output file），下载位置不同，注意连同中括号替换路径。

.. hint::

    ``[drive letter]`` 可以使用 ``sudo fdisk -l`` 进行查看，应当注意它是U盘驱动器的标识符（如 ``/dev/sdb`` ），**不包括** 分区号（如 ``/dev/sdb1``）。


准备好启动盘后，重启电脑，从U盘进入系统，顺着安装引导进行安装即可。


.. figure:: figures/manjaro.png
    :align: center
    :figwidth: 80%



更换镜像源
-----------------------------------------

安装完 Linux 系统后的第一件事莫过于更换镜像源和更新系统，Manjaro 换源非常简单，打开终端运行以下命令：

.. code-block:: bash

    sudo pacman-mirrors -i -c China -m rank


在弹出的窗口进行选择即可完成换源。进一步可以使用 ``vi /etc/pacman.d/mirrorlist`` 进行确认。然后，运行以下命令更新系统：

.. code-block:: bash

    sudo pacman -Syu



安装软件
-----------------------------------------

Manjaro 系统包管理的命令是 ``pacman`` ，为了使用强大的 AUR （Arch User Repository），可以安装并使用 ``yay`` 对软件进行管理：

.. code-block:: bash

    sudo pacman -S yay                                          # 安装 yay
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save      # 设置 AUR 镜像站


此后 ``sudo pacman`` 命令可以用 ``yay`` 代替了。绝大部分常用软件都可以不加额外配置地使用 ``yay -S`` 进行安装，是不是非常方便呢：

.. code-block:: bash

    yay -S base-devel                   # 基本打包工具，yay 安装软件可能用到
    yay -S zotero                       # Zotero
    yay -S nutstore                     # 坚果云
    yay -S visual-studio-code-bin       # VS Code
    yay -S youdao-dict                  # 有道词典
    yay -S qqmusic                      # QQ音乐
    yay -S vmware-workstation           # VM-Ware 虚拟机
    yay -S thefuck                      # 命令输入错误后输入 `fuck` 进行纠错
    yay -S mlocate                      # 文件查找
    yay -S obs-studio                   # OBS Studio
    yay -S enca                         # 文件编码转换：enca -L chinese -x utf-8 *
    yay -S bash-completion              # 终端自动补全功能


不确定软件名字的时候，可以使用命令 ``yay -Ss <pkgname>`` 进行搜索，或者在 `AUR 仓库镜像站 <https://aur.tuna.tsinghua.edu.cn/>`_ 搜索。


.. note::

    Manjaro 自带最新版本 Git ，嘿嘿。



下面记录一些需要少许配置的软件安装。


Vim
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vim 是一个很强的编辑器，几乎所有 Linux 发行版都会内置，但自带的通常不能把文件内容复制到系统剪切板，为此可以安装 gVim：

.. code-block:: bash

    yay -S gvim


可以通过 ``vim ~/.vimrc`` 编辑文件对 Vim 进行配置，例如：

.. code-block:: text

    syntax on
    set number
    set autoindent
    set smartindent
    set tabstop=4
    set expandtab
    set shiftwidth=4
    set fileencodings=utf8

    nnoremap j gj
    nnoremap k gk


最后两行是参考 `这篇教程 <https://vimjc.com/vim-line-downward.html>`_ 重新映射了 Vim 的换行功能。

Vim 对新手不是特别友好，我也只是在提交 Git 的时候图方便用一下，它的配置可以非常复杂，这里就不介绍了（实际上是我不会）。



中文输入法
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

首先安装 ``fcitx5`` 框架，唔……老命令换新名：

.. code-block:: bash

    yay -S fcitx5-im


使用 ``vim ~/.pam_environment`` 新建文件，添加以下内容以设置 ``fcitx5`` 的环境变量：

.. code-block:: text

    INPUT_METHOD  DEFAULT=fcitx5
    GTK_IM_MODULE DEFAULT=fcitx5
    QT_IM_MODULE  DEFAULT=fcitx5
    XMODIFIERS    DEFAULT=\@im=fcitx5


然后就可以安装具体的输入法了，我使用的是 `Rime <https://rime.im/>`_ ，于是安装命令是：

.. code-block:: bash

    yay -S fcitx5-rime


安装完成之后需要注销用户重新登录系统，然后在开始菜单找到并打开 ``Fcitx5 Configuration`` ，点击 “添加输入法” 按钮，搜索并选择 Rime 即可。

.. hint::

    Rime 是一款可高度自定义的输入法，单是它的配置就可以写很多教程，这里我不想写的太多。不愿意折腾的朋友当然可以使用 ``yay -S fcitx-sogoupinyin`` 安装搜狗输入法。



.. 哈哈，看看你发现了什么？我的 Rime 配置方案：极简主义（划掉，就是懒）
.. 复制这个配置的话，一定要保持缩进，把 patch 前的列都删除（Vim中 Ctrl+v）可以进入列编辑。

.. >>>>>>>>>>>>>>>>>> .local/share/fcitx5/rime/default.custom.yaml <<<<<<<<<<<<<<<<<<
.. patch:
..     menu/page_size: 9           # 候选字数量


.. >>>>>>>>>>>>>>>>>> .local/share/fcitx5/rime/default.custom.yaml <<<<<<<<<<<<<<<<<<
.. patch:
..     style/horizontal: true


.. >>>>>>>>>>>>>>>>>> .local/share/fcitx5/rime/luna_pinyin.custom.yaml <<<<<<<<<<<<<<<<<<
..     # luna_pinyin.custom.yaml
..     #
..     # 【朙月拼音】模糊音定製模板
..     #   佛振配製 :-)
..     #
..     # 位置：
..     # ~/.config/ibus/rime  (Linux)
..     # ~/Library/Rime  (Mac OS)
..     # %APPDATA%\Rime  (Windows)
..     #
..     # 於重新部署後生效
..     #
    
..     patch:
..         "speller/algebra":
..             - erase/^xx$/ # 第一行保留
    
..             # 模糊音定義
..             # 需要哪組就刪去行首的 # 號，單雙向任選
..             #- derive/^([zcs])h/$1/             # zh, ch, sh => z, c, s
..             #- derive/^([zcs])([^h])/$1h$2/     # z, c, s => zh, ch, sh
    
..             #- derive/^n/l/                     # n => l
..             #- derive/^l/n/                     # l => n
    
..             # 這兩組一般是單向的
..             #- derive/^r/l/                     # r => l
    
..             #- derive/^ren/yin/                 # ren => yin, reng => ying
..             #- derive/^r/y/                     # r => y
    
..             # 下面 hu <=> f 這組寫法複雜一些，分情況討論
..             #- derive/^hu$/fu/                  # hu => fu
..             #- derive/^hong$/feng/              # hong => feng
..             #- derive/^hu([in])$/fe$1/          # hui => fei, hun => fen
..             #- derive/^hu([ao])/f$1/            # hua => fa, ...
    
..             #- derive/^fu$/hu/                  # fu => hu
..             #- derive/^feng$/hong/              # feng => hong
..             #- derive/^fe([in])$/hu$1/          # fei => hui, fen => hun
..             #- derive/^f([ao])/hu$1/            # fa => hua, ...
    
..             # 韻母部份
..             #- derive/^([bpmf])eng$/$1ong/      # meng = mong, ...
..             - derive/([ei])n$/$1ng/ # en => eng, in => ing
..             - derive/([ei])ng$/$1n/ # eng => en, ing => in
    
..             # 樣例足夠了，其他請自己總結……
    
..             # 反模糊音？
..             # 誰說方言沒有普通話精確、有模糊音，就能有反模糊音。
..             # 示例爲分尖團的中原官話：
..             #- derive/^ji$/zii/   # 在設計者安排下鳩佔鵲巢，尖音i只好雙寫了
..             #- derive/^qi$/cii/
..             #- derive/^xi$/sii/
..             #- derive/^ji/zi/
..             #- derive/^qi/ci/
..             #- derive/^xi/si/
..             #- derive/^ju/zv/
..             #- derive/^qu/cv/
..             #- derive/^xu/sv/
..             # 韻母部份，只能從大面上覆蓋
..             #- derive/^([bpm])o$/$1eh/          # bo => beh, ...
..             #- derive/(^|[dtnlgkhzcs]h?)e$/$1eh/  # ge => geh, se => sheh, ...
..             #- derive/^([gkh])uo$/$1ue/         # guo => gue, ...
..             #- derive/^([gkh])e$/$1uo/          # he => huo, ...
..             #- derive/([uv])e$/$1o/             # jue => juo, lve => lvo, ...
..             #- derive/^fei$/fi/                 # fei => fi
..             #- derive/^wei$/vi/                 # wei => vi
..             #- derive/^([nl])ei$/$1ui/          # nei => nui, lei => lui
..             #- derive/^([nlzcs])un$/$1vn/       # lun => lvn, zun => zvn, ...
..             #- derive/^([nlzcs])ong$/$1iong/    # long => liong, song => siong, ...
..             # 這個辦法雖從拼寫上做出了區分，然而受詞典制約，候選字仍是混的。
..             # 只有真正的方音輸入方案纔能做到！但「反模糊音」這個玩法快速而有效！
    
..             # 模糊音定義先於簡拼定義，方可令簡拼支持以上模糊音
..             - abbrev/^([a-z]).+$/$1/ # 簡拼（首字母）
..             - abbrev/^([zcs]h).+$/$1/ # 簡拼（zh, ch, sh）
    
..             # 以下是一組容錯拼寫，《漢語拼音》方案以前者爲正
..             - derive/^([nl])ve$/$1ue/ # nve = nue, lve = lue
..             - derive/^([jqxy])u/$1v/ # ju = jv,
..             - derive/un$/uen/ # gun = guen,
..             - derive/ui$/uei/ # gui = guei,
..             - derive/iu$/iou/ # jiu = jiou,
    
..             # 自動糾正一些常見的按鍵錯誤
..             - derive/([aeiou])ng$/$1gn/ # dagn => dang
..             - derive/([dtngkhrzcs])o(u|ng)$/$1o/ # zho => zhong|zhou
..             - derive/ong$/on/ # zhonguo => zhong guo
..             - derive/ao$/oa/ # hoa => hao
..             - derive/([iu])a(o|ng?)$/a$1$2/ # tain => tian
    
..         # 分尖團後 v => ü 的改寫條件也要相應地擴充：
..         #'translator/preedit_format':
..         #  - "xform/([nljqxyzcs])v/$1ü/"
    
..         "punctuator/import_preset": symbols
..         "recognizer/patterns/punct":
..             "^/([A-Z|a-z]*|[0-9]|10)$"
..             #  符号快速上屏
..         punctuator:
..             import_preset: symbols
..             half_shape:
..                 "#": "#"
..                 "`": "`"
..                 "~": "~"
..                 "@": "@"
..                 "=": "="
..                 "/": ["/", "÷"]
..                 '\': "、"
..                 "'": { pair: ["「", "」"] }
..                 "[": "【" 
..                 "]": "】"
..                 "{": ["{", "｛", "『", "〖"]
..                 "}": ["}", "｝", "』", "〗"]
..                 "$": ["¥", "$", "€", "£", "¢", "¤"]
..                 "<": "《"
..                 ">": "》"
..         recognizer:
..             patterns:
..                 email: "^[A-Za-z][-_.0-9A-Za-z]*@.*$"
..                 uppercase: "[A-Z][-_+.'0-9A-Za-z]*$"
..                 url: "^(www[.]|https?:|ftp[.:]|mailto:|file:).*$|^[a-z]+[.].+$"
..                 punct: "^/([a-z]+|[0-9]0?)$"
..         switches/@0/reset: 0        # 默认状态：0为中文，1为英文
    

微信 QQ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

微信和 QQ 无疑是基于 Wine 技术的，通常在 Ubuntu 等 Debian 系发行版下要经过繁琐的设置，但是在 Manjaro 下安装十分简单：

.. code-block:: bash

    yay -S deepin-wine-wechat               # wine 微信
    yay -S deepin-wine-qq                   # wine QQ


由于 Wine 本身的问题，使用时可能会出现一些问题，常见的问题和解决方案有：

.. code-block:: bash

    # 微信中文乱码
    yay -S wqy-zenhei wqy-microhei                      # 安装文泉译黑体

    # 微信最小化出现透明窗口
    /opt/apps/com.qq.weixin.deepin/files/run.sh -d      # 切换到 deepin-wine

    # QQ 打不开
    /opt/apps/com.qq.im.deepin/files/run.sh -d          # 切换另一个 deepin-wine

    # 高分辨率屏幕下，界面字体过小
    WINEPREFIX=~/.deepinwine/Deepin-WeChat/ /usr/bin/deepin-wine5 winecfg


最后调整界面字体时， ``Deepin-WeChat`` 对应的是微信，QQ 应当做相应替换。运行后会弹出设置窗口，在 “显示” 选项卡中调整 “屏幕分辨率” 的 DPI 即可。将默认值 96 改为 144 即可实现 150% 的缩放效果。


MATLAB
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

从官网下载的 ``.zip`` 压缩包如果直接解压可能导致无法打开安装文件，使用下面的命令进行解压：

.. code-block:: bash

    unzip -X -K matlab_R2021a_glnxa64.zip -d installMATLAB/


从终端进入解压出来的 ``installMATLAB`` 文件夹，使用 ``./install`` 调用安装程序即可根据用户界面按顺序进行安装。

为了将 MATLAB 添加到开始菜单，使用 ``sudo vim /usr/share/applications/MATLAB.desktop`` 创建文件，并写入以下内容（注意安装路径）

.. code-block:: text

    [Desktop Entry]
    Type=Application
    Name=MATLAB
    GenericName=MATLAB R2021a
    Comment=MATLAB: The Language of Technical Computing
    Exec=sh /home/xiaocy/MATLAB/R2021a/bin/matlab -desktop
    Icon=/home/xiaocy/MATLAB/R2021a/toolbox/nnet/nnresource/icons/matlab.png
    StartupNotify=true
    Terminal=false
    Categories=Development;MATLAB;


KDE 桌面环境下，MATLAB 中右键 “Open Current Folder in File Manager” 可能不工作，可按 `以下步骤 <https://ww2.mathworks.cn/matlabcentral/answers/496880-open-current-folder-in-file-manager-does-nothing-matlab-r2019b-on-kubuntu-19-10>`_ 进行设置：

#. 在终端使用 ``locate libQt5Core.so.5`` 确认库的位置；
#. 在 MATLAB 中新建启动脚本： ``edit(fullfile(userpath,'startup.m'))`` ；
#. 在启动脚本中添加以下内容，其中 ``/usr/lib/`` 是第一步搜索到的路径：

.. code-block:: MATLAB

    setenv('LD_LIBRARY_PATH', ['/usr/lib/:',getenv('LD_LIBRARY_PATH')]);


对于高分辨率屏幕，MATLAB 界面的字体显得略小，可在 MATLAB 命令行中进行调整：

.. code-block:: MATLAB

    s = settings;s.matlab.desktop.DisplayScaleFactor
    s.matlab.desktop.DisplayScaleFactor.PersonalValue = 1.5


对于双显卡电脑（一般是笔记本电脑），绘图时可能出现无法使用独立显卡进行渲染的情况，通常给出 “MATLAB禁用了一些高级图形功能” 的警告或者直接抛出 OpenGL 相关的错误。为此，可在命令行使用 `以下命令 <https://www.mathworks.com/matlabcentral/answers/239279-hardware-based-opengl-on-linux>`_ 启动 MATLAB：

.. code-block:: bash

    export MESA_LOADER_DRIVER_OVERRIDE=i965; matlab


进一步，若想保持这种设置，可将快捷方式的设置改为：

.. code-block:: text

    Exec=env MESA_LOADER_DRIVER_OVERRIDE=i965 /home/xiaocy/MATLAB/R2021a/bin/matlab -desktop



TeX Live
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

下载 TeX Live 的镜像文件，挂载后使用 ``sodu ./install-tl`` 即可安装。安装完成后需要在 ``~/.bashrc`` 中设置路径：

.. code-block:: text

    export MANPATH=/usr/local/texlive/2021/texmf-dist/doc/man:${MANPATH}
    export INFOPATH=/usr/local/texlive/2021/texmf-dist/doc/info:${INFOPATH}
    export PATH=/usr/local/texlive/2021/bin/x86_64-linux:${PATH}


同样注意安装路径可能有所不同。最后运行 ``source .bashrc`` 刷新即可。




Inkscape
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Inkscape <https://inkscape.org/>`_ 是我最喜欢的绘图软件，它的安装非常简单：

.. code-block:: bash

    yay -S inkscape


除此，我还喜欢为其安装 `TexText <https://textext.github.io/textext/>`_ 扩展以在绘图时使用 LaTeX 。虽然该扩展可以简单地使用 ``yay -S textext`` 进行安装，但这种方法偶尔会找不到 LaTeX 路径，因此建议从 `GitHub release page <https://github.com/textext/textext/releases>`_ 下载，并在安装时手动指定路径：

.. code-block:: bash

    python setup.py --pdflatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/pdflatex --xelatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/xelatex --lualatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/lualatex


TexText 扩展可以自己补充宏包，设置文件通常在 ``~/.config/inkscape/extensions/textext/default_packages.tex`` 。一般我会使用以下宏包：

.. code-block:: LaTeX

    \usepackage{metalogo}
    \usepackage[table]{xcolor}
    \usepackage{amsmath}
    \usepackage{amssymb}
    \usepackage{bm}
    \usepackage{newtxmath}
    \usepackage{siunitx}
    \usepackage[UTF8]{ctex}




Flameshot
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Linux 下对标 `Snipaste <https://www.snipaste.com/>`_ 的开源截图软件，安装很容易：

.. code-block::

    yay -S flameshot


我喜欢给这个截图工具设置全局快捷键，可以打开系统设置 → 快捷键 → 自定义快捷键 → 编辑 → 新建 → 全局快捷键 → 命令/URL。快捷键可以自己定义，绑定的命令应当设置为 ``flameshot gui`` 。



系统设置
-----------------------------------------

系统设置因个人喜好可以随便配置，这也得益于 KDE 的灵活性。这里简要记录一些常用的设置。



高分辨率屏幕缩放
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Manjaro 对高分辨率屏幕的支持很好，只需要打开系统设置 → （硬件）显示监视器 → 显示设置 → 全局缩放。将其设置为 150% 即可（取决于个人喜好，也可 125%）。 


Fn 键设置
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

如果键盘的 ``Fn`` 键不可用，或者默认处于开启状态，希望默认关闭，可以在参考 `Arch Wiki <https://wiki.archlinux.org/title/Apple_Keyboard>`_ ，在管理员身份下运行以下命令：

.. code-block:: bash

    echo 2 >> /sys/module/hid_apple/parameters/fnmode


如果想要这个设置永久生效，可以在 ``/etc/modprobe.d/hid_apple.conf`` 文件中添加以下内容：

.. code-block:: text

    options hid_apple fnmode=2



GRUB 基本设置
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

设置启动选项，只需要 ``sudo vim /etc/default/grub`` 编辑设置文件即可，我只动过以下两条：


.. code-block:: text

    GRUB_TIMEOUT=0                  # 启动等待时间
    GRUB_TIMEOUT_STYLE=hidden       # 样式：hidden 或 menu


改动之后运行 ``sudo update-grub`` 刷新。

.. warning::

    GRUB 是很关键的系统文件，我曾经折腾 Ubuntu 时瞎改 GRUB 导致系统无法启动，新手改一下启动时间和样式就好，其他最好不乱动。
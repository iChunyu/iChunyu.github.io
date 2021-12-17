# Manjaro 系统安装


尝试过 Debian 系的 deepin、Ubuntu 和它的衍生版 Pop!_OS，都被各种各样的 Bug 劝退。后来尝试了 Arch 系的 Manjaro，唔，这真的是一款非常令人舒适的 Linux 发行版！来跟我一起折腾吧！

<!--more-->


## 安装系统

[Manjaro](https://manjaro.org/) 的系统镜像可以从官网下载，为了提高下载速度，可以从国内镜像站下载，例如我自己常用的 [清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/)。Manjaro 有 XFCE、KDE、GNOME 三种官方桌面可供选择，而社区提供更多其他桌面环境。这里我个人非常推荐 KDE 版本。

准备一个空U盘制作系统启动盘，Windows 用户可以使用 [Rufus](https://rufus.ie/) 等工具通过用户界面对镜像文件进行烧写，对于 Linux 用户，可以按如下方式使用 `dd` 命令：

``` bash
sudo dd bs=4M if=[/path/to/manjaro.iso] of=/dev/sd[drive letter] status=progress oflag=sync
```

命令中的 `if` 和 `of` 分别代表输入文件（input file）和输出文件（output file），下载位置不同，注意连同中括号替换路径。

{{< admonition note>}}
`[drive letter]` 可以使用 `sudo fdisk -l` 进行查看，应当注意它是 U 盘驱动器的标识符（如 `/dev/sdb` ），**不包括** 分区号（如 `/dev/sdb1`）。
{{< /admonition >}}

准备好启动盘后，重启电脑，从U盘进入系统，顺着安装引导进行安装即可。

<div align=center>
    <img src=manjaro.png width=70% />
</div>

## 更换镜像源

安装完 Linux 系统后的第一件事莫过于更换镜像源和更新系统，Manjaro 换源非常简单，打开终端运行以下命令：

``` bash
sudo pacman-mirrors -i -c China -m rank
```

在弹出的窗口进行选择即可完成换源。进一步可以使用 `vi /etc/pacman.d/mirrorlist` 进行确认。然后，运行以下命令更新系统：

``` bash
sudo pacman -Syu
```

## 安装软件

Manjaro 系统包管理的命令是 `pacman` ，为了使用强大的 AUR （Arch User Repository），可以安装并使用 `yay` 对软件进行管理：

``` bash
sudo pacman -S yay                                          ## 安装 yay
yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save      ## 设置 AUR 镜像站
```

此后 `sudo pacman` 命令可以用 `yay` 代替了。绝大部分常用软件都可以不加额外配置地使用 `yay -S` 进行安装，是不是非常方便呢：

``` bash
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
```

不确定软件名字的时候，可以使用命令 `yay -Ss <pkgname>` 进行搜索，或者在 [AUR 仓库镜像站](https://aur.tuna.tsinghua.edu.cn/) 搜索。


Manjaro 自带最新版本 Git ，真不错。下面记录一些需要少许配置的其他软件的安装。

### Vim

Vim 是一个很强的编辑器，几乎所有 Linux 发行版都会内置，但自带的通常不能把文件内容复制到系统剪切板，为此可以安装 gVim：

``` bash
yay -S gvim
```

可以通过 `vim ~/.vimrc` 编辑文件对 Vim 进行配置，例如：

``` text
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
```

最后两行是重新映射了 Vim 的换行功能，相关的使用说明可以参考 [Vim 简介]({{< ref "../vim/index.md" >}})。

### 中文输入法

首先安装 `fcitx5` 框架，唔......老命令换新名：

``` bash
yay -S fcitx5-im
```

使用 `vim ~/.pam_environment` 新建文件，添加以下内容以设置 `fcitx5` 的环境变量：

``` text
INPUT_METHOD  DEFAULT=fcitx5
GTK_IM_MODULE DEFAULT=fcitx5
QT_IM_MODULE  DEFAULT=fcitx5
XMODIFIERS    DEFAULT=\@im=fcitx5
```

然后就可以安装具体的输入法了，例如 [Rime](https://rime.im/) 可以使用如下命令进行安装：

``` bash
yay -S fcitx5-rime
```

安装完成之后需要注销用户重新登录系统，然后在开始菜单找到并打开 `Fcitx5 Configuration` ，点击 "添加输入法" 按钮，搜索并选择 Rime 即可。Rime 是一款可高度自定义的输入法，单是它的配置就可以写很多教程，这里我不想写的太多。不愿意折腾的朋友当然可以使用 `fcitx5` 自带的拼音输入法，还能安装 `fcitx5-material-color` 更换皮肤哟～


### 微信 QQ

微信和 QQ 无疑是基于 Wine 技术的，通常在 Ubuntu 等 Debian 系发行版下要经过繁琐的设置，但是在 Manjaro 下安装十分简单：

``` bash
yay -S deepin-wine-wechat               # wine 微信
yay -S deepin-wine-qq                   # wine QQ
```

由于 Wine 本身的问题，使用时可能会出现一些问题，常见的问题和解决方案有：

``` bash
## 微信中文乱码
yay -S wqy-zenhei wqy-microhei                      # 安装文泉译黑体

## 微信最小化出现透明窗口
/opt/apps/com.qq.weixin.deepin/files/run.sh -d      # 切换到 deepin-wine

## QQ 打不开
/opt/apps/com.qq.im.deepin/files/run.sh -d          # 切换另一个 deepin-wine

## 高分辨率屏幕下，界面字体过小
WINEPREFIX=~/.deepinwine/Deepin-WeChat/ /usr/bin/deepin-wine5 winecfg
```

最后调整界面字体时， `Deepin-WeChat` 对应的是微信，QQ 应当做相应替换。运行后会弹出设置窗口，在 "显示" 选项卡中调整 "屏幕分辨率" 的 DPI 即可。将默认值 96 改为 144 即可实现 150% 的缩放效果。

### MATLAB

从官网下载的 `.zip` 压缩包如果直接解压可能导致无法打开安装文件，使用下面的命令进行解压：

``` bash
unzip -X -K matlab_R2021a_glnxa64.zip -d installMATLAB/
```

从终端进入解压出来的 `installMATLAB` 文件夹，使用 `./install` 调用安装程序即可根据用户界面按顺序进行安装。

为了将 MATLAB 添加到开始菜单，使用 `sudo vim /usr/share/applications/MATLAB.desktop` 创建文件，并写入以下内容（注意安装路径）

``` text
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
```

KDE 桌面环境下，MATLAB 中右键 "Open Current Folder in File Manager" 可能不工作，可按 [以下步骤](https://ww2.mathworks.cn/matlabcentral/answers/496880-open-current-folder-in-file-manager-does-nothing-matlab-r2019b-on-kubuntu-19-10) 进行设置：

1. 在终端使用 `locate libQt5Core.so.5` 确认库的位置；
2. 在 MATLAB 中新建启动脚本： `edit(fullfile(userpath,'startup.m'))` ；
3. 在启动脚本中添加以下内容，其中 `/usr/lib/` 是第一步搜索到的路径：

``` MATLAB
setenv('LD_LIBRARY_PATH', ['/usr/lib/:',getenv('LD_LIBRARY_PATH')]);
```

对于高分辨率屏幕，MATLAB 界面的字体显得略小，可在 MATLAB 命令行中进行调整：

``` MATLAB
s = settings;s.matlab.desktop.DisplayScaleFactor
s.matlab.desktop.DisplayScaleFactor.PersonalValue = 1.5
```

对于双显卡电脑（一般是笔记本电脑），绘图时可能出现无法使用独立显卡进行渲染的情况，通常给出 "MATLAB禁用了一些高级图形功能" 的警告或者直接抛出 OpenGL
相关的错误。为此，可在命令行使用 [以下命令](https://www.mathworks.com/matlabcentral/answers/239279-hardware-based-opengl-on-linux)
启动 MATLAB：

``` bash
export MESA_LOADER_DRIVER_OVERRIDE=i965; matlab
```

进一步，若想保持这种设置，可将快捷方式的设置改为：

``` text
Exec=env MESA_LOADER_DRIVER_OVERRIDE=i965 /home/xiaocy/MATLAB/R2021a/bin/matlab -desktop
```

### TeX Live

下载 TeX Live 的镜像文件，挂载后使用 `sudo ./install-tl` 即可安装。安装完成后需要在 `~/.bashrc` 中设置路径：

``` text
export MANPATH=/usr/local/texlive/2021/texmf-dist/doc/man:${MANPATH}
export INFOPATH=/usr/local/texlive/2021/texmf-dist/doc/info:${INFOPATH}
export PATH=/usr/local/texlive/2021/bin/x86_64-linux:${PATH}
```

同样注意安装路径可能有所不同。最后运行 `source .bashrc` 刷新即可。

### Inkscape

[Inkscape](https://inkscape.org/) 是我最喜欢的绘图软件，它的安装非常简单：

``` bash
yay -S inkscape
```

除此，我还喜欢为其安装 [TexText](https://textext.github.io/textext/) 扩展以在绘图时使用 LaTeX 。虽然该扩展可以简单地使用 `yay -S textext` 进行安装，但这种方法偶尔会找不到 LaTeX 路径，因此建议从 [GitHub release page](https://github.com/textext/textext/releases) 下载，并在安装时手动指定路径：

``` bash
python setup.py --pdflatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/pdflatex --xelatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/xelatex --lualatex-executable=/usr/local/texlive/2021/bin/x86_64-linux/lualatex
```

可以编辑 `~/.config/inkscape/extensions/textext/default_packages.tex` 对 TexText 宏包进行设置。一般我会使用以下宏包：

``` LaTeX
\usepackage{metalogo}
\usepackage[table]{xcolor}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{bm}
\usepackage{newtxmath}
\usepackage{siunitx}
\usepackage[UTF8]{ctex}
```

### Flameshot

Linux 下对标 [Snipaste](https://www.snipaste.com/) 的开源截图软件，安装很容易：

``` 
yay -S flameshot
```

我喜欢给这个截图工具设置全局快捷键，可以打开系统设置 → 快捷键 → 自定义快捷键 → 编辑 → 新建 → 全局快捷键 → 命令/URL。快捷键可以自己定义，绑定的命令应当设置为 `flameshot gui` 。

## 系统设置

系统设置因个人喜好可以随便配置，这也得益于 KDE 的灵活性。这里简要记录一些常用的设置。

### 高分辨率屏幕缩放

Manjaro 对高分辨率屏幕的支持很好，只需要打开系统设置 → （硬件）显示监视器 → 显示设置 → 全局缩放。将其设置为 150% 即可（取决于个人喜好，也可 125%）。

### Fn 键设置

如果键盘的 `Fn` 键不可用，或者默认处于开启状态，希望默认关闭，可以在参考 [Arch Wiki](https://wiki.archlinux.org/title/Apple_Keyboard)，在管理员身份下运行以下命令：

``` bash
echo 2 >> /sys/module/hid_apple/parameters/fnmode
```

如果想要这个设置永久生效，可以在 `/etc/modprobe.d/hid_apple.conf` 文件中添加以下内容：

``` text
options hid_apple fnmode=2
```

### GRUB 基本设置

设置启动选项，只需要 `sudo vim /etc/default/grub` 编辑设置文件即可，我只动过以下两条：

``` text
GRUB_TIMEOUT=0                  ## 启动等待时间
GRUB_TIMEOUT_STYLE=hidden       ## 样式：hidden 或 menu
```

改动之后运行 `sudo update-grub` 刷新。

{{< admonition danger >}}
GRUB 是很关键的系统文件，我曾经折腾 Ubuntu 时瞎改 GRUB 导致系统无法启动，新手改一下启动时间和样式就好，其他最好不乱动。
{{< /admonition >}}


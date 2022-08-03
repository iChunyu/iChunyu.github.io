---
title: "Arch Linux 系统安装"
date: 2021-12-26
lastmod: 2021-12-31
tags: ["Arch","Linux","操作系统"]
categories: ["生命在于折腾"]
draft: false
---

最近有兴趣折腾了一下 Arch Linux，并在虚拟机中成功安装。将安装步骤记录于此，下一次就真机实战。

<!--more-->


## 安装命令汇总

为了方便查阅，将本次涉及到的所有命令先汇总如下，以便查阅。

{{< admonition note >}}
命令中缩进的部分表示进入了交互模式或者打开了文件，文件只给出关键部分的设置以供参考。由中括号如 `[hostname]` 给出的变量可能会因机器而不同，使用时应当连同中括号一起替换掉。
{{< /admonition >}}

```bash
# 确认 UEFI 模式
ls /sys/firmware/efi/efivars                # 有输出即可

# 连接网络
ip link                                     # 检查网络接口
iwctl                                       # 交互式连接无线网络
    device list                             # 列出无线网卡设备名
    station [wlan0] scan                    # 扫描网络 [] 内部待替换
    station [wlan0] get-networks            # 列出所有 wifi 网络
    station [wlan0] connect [wifi-name]     # 进行连接
    exit                                    # 退出交互模式
ping bilibili.com                           # 检查网络连接

# 同步时间
timedatectl set-ntp true                    # 将系统时间与网络时间进行同步
timedatectl status                          # 检查服务状态

# 更改软件镜像源
vim /etc/pacman.d/mirrorlist
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
pacman -Syy

# 分区
fdisk -l
fdisk /dev/sd[a]                            # SATA协议：sd[a]，NVME 协议：nvme[1]n1
    # 交互式新建 EFI 分区、根目录、swap 等
mkfs.fat -F32 /dev/sda[1]                   # 格式化 EFI 分区
mkfs.ext4 /dev/sda[2]                       # 根目录
mkfs.ext4 /dev/sda[3]                       # 其他目录，如 /home
mkswap /dev/sda[4]                          # 创建 swap 分区
fdisk -l

# 挂载
mount /dev/sda[2] /mnt                      # 一定要先挂载根目录
mkdir /mnt/boot
mount /dev/sda[1] /mnt/boot
mkdir /mnt/home
mount /dev/sda[3] /mnt/home
swapon /dev/sda[4]

# 安装系统
pacstrap /mnt base linux linux-firmware     # 安装系统
genfstab -U /mnt >> /mnt/etc/fstab          # 生成 fstab 文件

# 切换到新系统
arch-chroot /mnt

# 主机配置
echo '[hostname]' > /etc/hostname           # 设置主机名
pacman -S vim                               # 安装 vim
vim /etc/hosts
    # 填入以下内容
    127.0.0.1   localhost
    ::1         localhost
    127.0.1.1   [hostname].localdomain  [hostname]

# 时间设置
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     # 设置时区
hwclock --systohc                                           # 同步时间

# 区域设置
vim /etc/locale.gen
    # 去掉注释
    en_US.UTF-8 UTF-8
    zh_CN.UTF-8 UTF-8
locale-gen
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf

# root 密码
passwd

# GRUB 设置
pacman -S intel-ucode                       # AMD CPU 使用 amd-ucode
pacman -S grub efibootmgr os-prober
uname -m                                    # 查看 CPU 架构
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
vim /etc/default/grub                       # 适当调整，可以跳过
grub-mkconfig -o /boot/grub/grub.cfg

# 网络管理软件
pacman -S dhcpcd iwd

# 重启
exit
umount -R /mnt
reboot

# 进入新系统
systemctl enable --now dhcpcd
systemctl start iwd             # 无线网络
iwctl                                       # 交互式连接无线网络
    device list                             # 列出无线网卡设备名
    station [wlan0] scan                    # 扫描网络 [] 内部待替换
    station [wlan0] get-networks            # 列出所有 wifi 网络
    station [wlan0] connect [wifi-name]     # 进行连接
    exit                                    # 退出交互模式
ping bilibili.com                           # 使用 Ctrl+C 停止测试
pacman -Syyu                                # 更新系统

# 创建普通用户
pacman -S sudo
useradd -m -G wheel [username]
passwd [username]
EDITOR=vim visudo
    # 去掉注释（保留%）
    %wheel ALL=(ALL) ALL

# 安装 KDE 桌面环境
pacman -S plasma-meta konsole dolphin git base-devel
systemctl enable sddm
reboot

# 进入桌面环境
sudo systemctl disable iwd                  # 关闭 iwd 开机自启
sudo systemctl stop iwd                     # 立即关闭 iwd 服务
sudo systemctl enable --now NetworkManager  # 启动 NetworkManager 并确保开机自启
ping bilibili.com

# 修改软件镜像源设置
sudo vim /etc/pacman.conf
    # 删除 [multilib] 注释
    [multilib]
    Include = /etc/pacman.d/mirrorlist
sudo pacman -Syu

# 安装 AUR 管理软件 yay
git clone https://aur.archlinux.org/yay --depth 1
cd yay
export GO111MODULE=on                   # 临时 GO 换源
export GOPROXY=https://goproxy.cn
makepkg -si

# 中文配置
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki
vim ~/.pam_environment
    INPUT_METHOD    DEFAULT=fcitx5
    GTK_IM_MODULE   DEFAULT=fcitx5
    QT_IM_MODULE    DEFAULT=fcitx5
    XMODIFIERS      DEFAULT=\@im=fcitx5
    SDL_IM_MODULE   DEFAULT=fcitx
```


## 安装步骤说明

插入 U 盘启动盘，或者虚拟机中使用安装镜像文件，进入 Arch Linux 的安装环境，我们将看到黑底白字的命令行……那就准备开始吧！

### 确认启动模式

首先确认启动模式，运行下面的命令：

```bash
ls /sys/firmware/efi/efivars                # 有输出即可
```

运行后如果有很多变量输出，说明处于 UEFI 模式。如果出现错误，说明处于 BIOS（或 CSM）模式。这虽然不会都后面的步骤产生影响，但了解一下系统的启动方式还是有必要的。


### 连接网络

Arch Linux 的安装必须联网，有线网络应当会自动连接，可以直接使用 `ping` 来验证网络连接。若使用无线网，需要通过 `iwctl` 手动操作，具体步骤如下（缩进的代码表示进入交互模式）：

```bash
ip link                                     # 检查网络接口
iwctl                                       # 交互式连接无线网络
    device list                             # 列出无线网卡设备名
    station [wlan0] scan                    # 扫描网络 [] 内部待替换
    station [wlan0] get-networks            # 列出所有 wifi 网络
    station [wlan0] connect [wifi-name]     # 进行连接
    exit                                    # 退出交互模式
```

首先，使用 `ip link` 检查网络接口设置，通常情况下网络接口都是默认开启的。如果无法连接，可以使用命令 `ip link set [wlp0s20f3] up` 激活对应的网卡，然后重复联网操作。

使用 `iwtcl` 命令后，命令行会进入到相应的交互模式，这时候依次运行上面缩进部分的代码，扫描并连接网络即可。

最后，我们来 `ping` 一下哔哩哔哩，看看网络是否连通。

```bash
ping bilibili.com                           # 检查网络连接
```

如果出现“64 bytes from ...”之类的提示，则表示网络正常，使用组合键 <kbd>Ctrl</kbd> + <kbd>C</kbd> 停止连接测试即可。

### 同步时间

时间同步蛮重要的，具体我也说不清，跟着教程运行下面两个命令就可以了：

```bash
timedatectl set-ntp true                    # 将系统时间与网络时间进行同步
timedatectl status                          # 检查服务状态
```

### 更改软件镜像源

为了获得更快的下载速度，应当更换软件镜像源。我蛮喜欢 [清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn) 的，为此，首先运行下面的命令打开配置文件：

```bash
vim /etc/pacman.d/mirrorlist
```

可以看到很多默认配置，但这些源并不是都要使用的，优先级是从上往下递减，因此我们只需要将下面的配置放在最上面即可（`#` 是 Linux 配置文件的注释符）：

```text
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```
{{< admonition tip >}}
Vim 编辑器中，使用 `j`,`k`,`h`,`l` 分别对光标进行下、上、左、右的移动；按 `i` 可以插入文字。为了退出 Vim, 首先按 `Esc` 切换到普通模式，然后输入 `:wq` 回车即可保存并退出。
{{< /admonition>}}

{{< admonition note >}}
这里我们使用了 Vim 编辑器，这是个非常强大的上古神器。我之前写过 [Vim 简介]({{< ref "../vim/index.md" >}})，对它的冰山一角进行了拙劣的说明。虽不足以进阶，应付一下这里的基本编辑还是没问题的。
{{< /admonition >}}

更换软件镜像源后别忘了使用以下命令刷新一下：

```bash
pacman -Syy
```

### 分区

安装系统之前对硬盘进行分区，可以将不同的数据存放在不同的位置。例如，我在使用 Linux 时通常会将 `/home` 单独分区，这样在重装系统时很多配置和软件都可以保留并继续使用。Linux 分区与 Windows 有很大的不同，这里我不想多说，有兴趣的同学可以参看 [鸟叔的 Linux 私房菜](http://cn.linux.vbird.org)。

首先我们使用下面的命令查看当前的硬盘

```bash
fdisk -l
```

你会看到所有的硬盘都以 `/dev/xxx` 的形式，看上去就像一个个文件。我们忽略 `/dev/loop` 开头的东西，如果硬盘使用 SATA 协议，我们将看到形如 `sda`、`sdb` 等信息；如果硬盘是 NVME 协议，则会看到形如 `nvme0n1`、`nvme1n1` 等。如果硬盘已经分区，还会进一步列出各个分区信息。

我们以 SATA 协议的硬盘为例，并设这个硬盘的编号为 `sda`，那么我们可以运行下面的命令（再次提醒中括号内的内容，包括中括号本身，表示可变的参数，不同机器的参数可能不同）：

```bash
fdisk /dev/sd[a]                            # SATA协议：sd[a]，NVME 协议：nvme[1]n1
```

运行这个命令后将进入交互模式，根据提示，按 `m` 可以查看用法，按 `n` 可以新建分区等等。

在本例中，我在虚拟机中使用了空白的虚拟硬盘，因此我的操作如下，仅供参考：

```bash
# fdisk 交互命令
g       # 新建 GPT 分区表（忽略已有分区，重新分区）
n       # 回车选择默认起始点，然后输入 +512M 创建 EFI 分区
n       # 回车选择默认起始点，然后输入 +20G 创建根目录分区
n       # 回车选择默认起始点，然后输入 +20G 创建 /home 分区
n       # 回车选择默认起始点，然后输入 +1G 创建 swap 分区（一般为内存的一半左右即可）
w       # 保存并退出
```

执行完上述命令后，再次使用 `fdisk -l` 可以看到 `sda` 下面多出了 `sda1`、`sda2` 等分区。至此我们实际上只是对各个目标分区的大小进行了设置，真正使用还需要对各分区格式化，具体命令如下（`sda`后面的编号与分区创建的顺序相关，本例编号如中括号内容所示）：

```bash
mkfs.fat -F32 /dev/sda[1]                   # 格式化 EFI 分区
mkfs.ext4 /dev/sda[2]                       # 根目录
mkfs.ext4 /dev/sda[3]                       # 其他目录，如 /home
mkswap /dev/sda[4]                          # 创建 swap 分区
fdisk -l                                    # 查看分区结果
```

### 挂载

为了将系统安装进上面分区好的硬盘，需要将硬盘挂载到当前系统。初次接触 Linux 的同学可能对挂载这个操作有所疑惑，这里打个比方：比如你插了 U 盘，系统虽然知道你插了 U 盘，但是它不显示，你必须手动挂载，告诉系统把 U 盘的内容“映射”到某个文件夹下，这样在指定文件夹内就可以访问 U 盘内容了。如果用大家熟悉的 Windows 对比，当你插入 U 盘后，Windows 会自动将 U 盘“挂载”到一个新的分区，例如“F：可移动硬盘”；当你右键弹出 U 盘，但是还没有拔出时，“F：可移动硬盘”消失不见了，这就好像是 Linux 插入 U 盘但是没有挂载事的状态。

按照前人的经验，挂载时一定要先挂载根目录，常用的挂载点是 `/mnt` 。我们在上面分区时根目录是第二个分区（`sda2`），因此挂载顺序如下：

```bash
mount /dev/sda[2] /mnt                      # 一定要先挂载根目录
mkdir /mnt/boot                             # 新建 /boot 文件夹
mount /dev/sda[1] /mnt/boot                 # 挂载 EFI 分区
mkdir /mnt/home                             # 新建 /home 文件夹
mount /dev/sda[3] /mnt/home                 # 挂载 /home 分区
swapon /dev/sda[4]                          # 启用 swap 分区
```

至此，我们已经做好全部的安装准备了，开始正式安装 Arch Linux！

### 安装系统

前面准备那么久，激动了大半天，但说来还是有点小失望。因为安装 Arch Linux 只需要下面两条命令就可以了：

``` bash
pacstrap /mnt base linux linux-firmware     # 安装系统
genfstab -U /mnt >> /mnt/etc/fstab          # 生成 fstab 文件
```

但是别急，这只是安装了最基本的内容，要想成功启动，还需要进行基本配置工作。为此，我们使用下面的命令切换到新系统去

```bash
arch-chroot /mnt                            # 切换到新系统
```

### 主机配置

装好系统之后，得给系统起个好听的名字吧？使用下面的命令（替换掉中括号以及中括号里面的内容喔）：

```bash
echo '[hostname]' > /etc/hostname           # 设置主机名
```

然后我们需要编辑 hosts 文件，我们发现新系统没有内置 Vim，因此还需要使用下面的命令安装 Vim

```bash
pacman -S vim                               # 安装 vim
```

{{< admonition question >}}
`pacman` 是 Arch 的软件管理（**pac**kage **man**nager），唔，也是吃豆人啦。
{{< /admonition >}}

然后使用 Vim 打开 hosts 文件

```bash
vim /etc/hosts
```

在里面填入以下内容，注意替换掉自己的主机名喔

```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   [hostname].localdomain  [hostname]
```

### 时间设置

Arch 内置了很多时区，我们只需要使用下面的命令创建相应的链接即可。注意国内的时区是上海而不是北京（我也不知道为什么）。

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     # 设置时区
hwclock --systohc                                           # 同步时间
```

### 区域设置

区域设置实际上是为了配置应用程序的默认格式，我们首先使用 Vim 打开配置文件：

```bash
vim /etc/locale.gen
```

找到 `en_US.UTF-8 UTF-8` 和 `zh_CN.UTF-8 UTF-8` ，去掉前面的注释即可。

{{< admonition tip >}}
简要说明一下这里的 Vim 使用：首先输入 `/en_US` 后回车，并按 `n` 查找下一处；光标到达目标位置后按 `0` 跳转到行首，按 `x` 删除注释（有空格的话再按一次 `x` 把空格也删掉，否则会逼死强迫症）。然后再输入 `/zh_CN` 回车，重复上述操作。最后输入 `:wq` 保存并退出即可。
{{< /admonition >}}

最后使用下面的命令生成相应配置即可。第二行表示使用英文，听说设置中文容易导致乱码。使用英文的另一个好处就是：如果程序出错，英文的错误提示更容易在网上搜到相关的解答方案。

```bash
locale-gen
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf
```

### root 密码

超级管理员，得悄悄设置个别人不知道的密码：

```bash
passwd
```

{{< admonition note >}}
Linux 终端在输入密码时屏幕上不会出现任何字符，不要觉得是键盘坏了……
{{< /admonition >}}


### GRUB 设置

一般的电脑都是 `x86_64` 架构，只需要根据 CPU 的不同安装不同的 ucode 即可。按照下面的命令一般不会出错：

```bash
pacman -S intel-ucode                       # AMD CPU 使用 amd-ucode
pacman -S grub efibootmgr os-prober
uname -m                                    # 查看 CPU 架构
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
vim /etc/default/grub                       # 适当调整，可以跳过
grub-mkconfig -o /boot/grub/grub.cfg
```


### 重启并进入新系统

至此，系统已经基本配置完成，在正式重启进入系统之前，千万别忘了安装网络管理软件。

```bash
pacman -S dhcpcd iwd
exit
umount -R /mnt
reboot
```

关机后拔掉 U 盘，或者在启动选项上稍微留心一下，确认进入了新安装的系统。


### 进入新系统

现在我们进入新系统啦，还是一片黑白的命令行……不管如何，先连上网再说。有线网络使用下面的命令一般就可以顺利上网了：

```bash
systemctl enable --now dhcpcd
```

无线网络还是通过 `iwctl` 连接，不过在使用前还需要启动 `iwd` 服务（新系统默认关闭）

```bash
systemctl start iwd                         # 启动无线网络服务
iwctl                                       # 交互式连接无线网络
    device list                             # 列出无线网卡设备名
    station [wlan0] scan                    # 扫描网络 [] 内部待替换
    station [wlan0] get-networks            # 列出所有 wifi 网络
    station [wlan0] connect [wifi-name]     # 进行连接
    exit                                    # 退出交互模式

```

最后确认一下网络链接，顺便更新一下系统：

```bash
ping bilibili.com                           # 使用 Ctrl+C 停止测试
pacman -Syyu                                # 更新系统
```

### 创建普通用户

如果稍微留心一下，你会发现命令行的提示符是 `#`，这代表目前你使用的是超级管理员账户（root）。这个账户的权限非常高，为了避免误操作导致系统问题，我们通常使用权限稍微低一点的普通用户；为了偶尔提升一下普通用户的权限，需要对普通用户进行设置，按照下面的操作即可：

```bash
pacman -S sudo
useradd -m -G wheel [username]
passwd [username]
EDITOR=vim visudo
```

最后一行将会打开 Vim 编辑器，我们使用 `/wheel` 定位到 `#%wheel ALL=(ALL) ALL`，删除前面的注释符 `#` 即可。

{{< admonition danger >}}
超级管理员用户具有非常高的权限，不信你可以在 root 账户下运行 `rm -rf /`。前提是运行完了别打我（狗头保命）。
{{< /admonition >}}


### 安装 KDE 桌面环境

终于到了最激动人心的时刻了，我们已经基本配置好了系统，现在为了日常使用，将安装图形界面。我个人比较喜欢 KDE 桌面，使用以下命令即可：

```bash
pacman -S plasma-meta konsole dolphin git base-devel
systemctl enable sddm
reboot
```

从这里开始，大家就可以完全跟随自己的爱好对系统进行配置，完全可以使用 GNOME、DDE 等各种桌面环境。这里介绍我自己的安装经历，仅作为参考。


### 进入桌面环境后的配置

重启后可以看到界面，使用上面创建的普通用户登陆即可。

进入桌面环境后，首当其冲的还是联网设置。安装 KDE 后默认你会安装 `NetworkManager`，这个服务与之前的 `iwd` 似乎存在冲突，因此我们要确保 `iwd` 关闭和 `NetworkManager` 启动，运行下面的命令（哦对，要使用 <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd> 打开终端）：

```bash
sudo systemctl disable iwd                  # 关闭 iwd 开机自启
sudo systemctl stop iwd                     # 立即关闭 iwd 服务
sudo systemctl enable --now NetworkManager  # 启动 NetworkManager 并确保开机自启
```

然后就可以从桌面左下角的 WiFi 图标进行网络连接了，接着测试网络连接：

```bash
ping bilibili.com
```

为了避免后面安装微信等软件是依赖的问题，我们要对镜像源配置文件进行修改。由于这次使用了普通用户，修改镜像源这种系统配置时需要使用 `sudo` 临时提高权限：

```bash
sudo vim /etc/pacman.conf
```

找到 `[multilib]` 删除相关注释，形如：

```text
[multilib]
Include = /etc/pacman.d/mirrorlist
```

然后再随手更新一下系统：

```bash
sudo pacman -Syu
```

### 安装 AUR 管理软件 yay

使用 Arch 的重要因素之一就是它的用户仓库（AUR, Arch User Repository）提供了非常多优秀的软件（例如可以一条命令安装微信）。为了使用 AUR，我们要手动安装其包管理器 `yay`。

```bash
git clone https://aur.archlinux.org/yay --depth 1
cd yay
export GO111MODULE=on                   # 临时 GO 换源
export GOPROXY=https://goproxy.cn
makepkg -si
```

安装 `yay` 需要从 GO 和 GitHub 下载相关依赖。受限于网络环境，两个网站可能无法访问。GO 的仓库可以通过上面的换源方法完成，GitHub 可能要修改 hosts，具体可以参考 [yay安装失败的解决方案](https://zhuanlan.zhihu.com/p/439805266)。

然后就可以用 `yay` 自由地玩耍了。

### 中文配置

最后简要分享一下中文的配置：

```bash
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki
vim ~/.pam_environment
```

前面三条命令分别是安装相应的中文字体、安装输入框架，最后需要对 fcitx5 进行配置，在打开的文件中写入以下内容即可：

```text
INPUT_METHOD    DEFAULT=fcitx5
GTK_IM_MODULE   DEFAULT=fcitx5
QT_IM_MODULE    DEFAULT=fcitx5
XMODIFIERS      DEFAULT=\@im=fcitx5
```

Arch Linux 的可玩性不限于此，剩下的请大家自行折腾～

## 参考文献

1. [【残酷难度】最全Arch Linux安装教程——打造真正属于你的操作系统](https://www.bilibili.com/video/BV11J411a7Tp).
2. [VirtualBox 安装 Arch Linux: 从新建虚拟机到图形界面](https://zhuanlan.zhihu.com/p/355826301).
3. [archlinux 基础安装](https://arch.icekylin.online/rookie/basic-install.html)
4. [Installation guide](https://wiki.archlinux.org/title/Installation_guide)
5. [yay安装失败的解决方案](https://zhuanlan.zhihu.com/p/439805266)

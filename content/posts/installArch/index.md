---
title: "Arch Linux 系统安装"
date: 2021-12-26T21:27:40+08:00
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
ls /sys/firmware/efi/efivars                # 确认 UEFI 模式

ip link                                     # 检查网络接口
iwctl                                       # 交互式连接无线网络
    device list                             # 列出无线网卡设备名
    station [wlan0] scan                    # 扫描网络 [] 内部待替换
    station [wlan0] get-networks            # 列出所有 wifi 网络
    station [wlan0] connect [wifi-name]     # 进行连接
    exit                                    # 退出交互模式
ping bilibili.com                           # 检查网络连接

timedatectl set-ntp true                    # 将系统时间与网络时间进行同步
timedatectl status                          # 检查服务状态

vim /etc/pacman.d/mirrorlist                # 更改软件源
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
pacman -Syy

fdisk -l
fdisk /dev/[sda]                            # SATA协议：sd[a]，NVME 协议：nvme[1]n1
    # 交互式新建 EFI 分区、根目录、swap 等
mkfs.fat -F32 /dev/sda[1]                   # 格式化 EFI 分区
mkfs.ext4 /dev/sda[2]                       # 根目录
mkfs.ext4 /dev/sda[3]                       # 其他目录，如 /home
mkswap /dev/sda[4]                          # swap
fdisk -l

mount /dev/sda[2] /mnt                      # 一定要先挂载根目录
mkdir /mnt/boot
mount /dev/sda[1] /mnt/boot
mkdir /mnt/home
mount /dev/sda[3] /mnt/home
swapon /dev/sda[4]

pacstrap /mnt base linux linux-firmware     # 安装系统
genfstab -U /mnt >> /mnt/etc/fstab          # 生成 fstab 文件

arch-chroot /mnt
pacman -S vim sudo

echo '[hostname]' > /etc/hostname           # 设置主机名
vim /etc/hosts
    # 填入以下内容
    127.0.0.1   localhost
    ::1         localhost
    127.0.1.1   [hostname].localdomain  [hostname]

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     # 设置时区
hwclock --systohc                                           # 同步时间

vim /etc/locale.gen
    # 去掉注释
    en_US.UTF-8 UTF-8
    zh_CN.UTF-8 UTF-8
locale-gen
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf

passwd

pacman -S intel-ucode           # amd-ucode
pacman -S grub efibootmgr os-prober
uname -m
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
vim /etc/default/grub
    # 适当调整
grub-mkconfig -o /boot/grub/grub.cfg

#pacman -S dhcpcd iwd
pacman -S dhcpcd networkmanager

exit
umount -R /mnt
reboot

systemctl enable --now dhcpcd
systemctl enable --now NetworkManager
#systemctl start iwd             # 无线网络
ping bilibili.com

pacman -Syyu
vim ~/.bash_profile
    # 添加内容
    export EDITOR='vim'

useradd -m -G wheel [username]
passwd [username]
EDITOR=vim visudo
    # 去掉注释（保留%）
    %wheel ALL=(ALL) ALL

pacman -S plasma-meta konsole dolphin git base-devel
systemctl enable sddm
reboot

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
```

（未完待续：安装具体说明）

<!-- 
sudo pacman -S ntfs-3g
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S ark 
sudo pacman -S packagekit-qt5 packagekit appstream-qt appstream # 确保 Discover（软件中心）可用，需重启
sudo pacman -S gwenview # 图片查看器

sudo pacman -S fcitx5-im # 输入法基础包组
sudo pacman -S fcitx5-chinese-addons # 官方中文输入引擎
sudo pacman -S fcitx5-pinyin-moegirl
vim ~/.pam_environment
    INPUT_METHOD DEFAULT=fcitx5
    GTK_IM_MODULE DEFAULT=fcitx5
    QT_IM_MODULE DEFAULT=fcitx5
    XMODIFIERS DEFAULT=\@im=fcitx5
    SDL_IM_MODULE DEFAULT=fcitx 
-->
---
title: "Spice使用方式"
date: 2022-05-27T17:18:21+08:00
draft: false
---

使用qxl的驱动方式



windows 需要天下载安装spice-agent的，

然后再virt-viewer。

释放光标快捷键  Ctrl+Alt+R

全屏快捷键   Shift+F11

#### 配置主板出现系统不兼容



！！！ 再次强调：CPU超频时，SPREAD SPECTRUM必须关闭，否则容易出现锁死cpu的情况。并且禁止C-state。。

！！！ 安装nv驱动的方式

https://forums.plex.tv/t/plex-hw-acceleration-in-lxc-container-anyone-with-success/219289/35

刷bios前必须clean cmos，微星这代主板应该都是这样，如果这步没做，重启必黑屏。
仅仅指用u盘flash，windows下update没试过


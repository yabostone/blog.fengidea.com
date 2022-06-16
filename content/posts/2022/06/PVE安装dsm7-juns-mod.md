---
title: "PVE安装dsm7 Juns Mod"
date: 2022-06-14T23:34:01+08:00
draft: false
---

==

注意不能安装DS918，因为需要cpu大于4代，这里选择配置cpu为kvm。

需要在配置文件中加入

```Bash
args: -device 'qemu-xhci,addr=0x18' -drive 'id=synoboot,file=/z2/data/images/DS3617xs_7.X.img,if=none,format=raw' -device 'usb-storage,id=synoboot,drive=synoboot,bootindex=5'
```

模拟USB启动，可能也要sata的启动，模拟unraid在虚拟机环境下的启动方式。注意修改file文件位置。

dsm打好驱动的在https://wp.gxnas.com/11849.html 网站上，

```Bash
https://dl.gxnas.com:1443/?dir=/%E9%BB%91%E7%BE%A4%E6%99%96/%E9%BB%91%E7%BE%A4%E6%99%96DSM6.24%E5%92%8CDSM7.x%E6%B5%8B%E8%AF%95%E7%89%88
```

网页处下载。

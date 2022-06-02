---
title: "刷新BIOS用编程器"
date: 2022-05-28T09:02:08+08:00
draft: false
---

刷新bios把bios刷蹦了，考虑用jspi刷。

现在找相关链接。

+ 
+ 我是指编程器读取备份出来，才有特有的mac地址，不过有这个贴纸也可以 

建议多买一个便宜的土豪金CH341A备用，兼容性佳 又可使用AsProgrammer 漢化版软件

https://www.bilibili.com/read/cv9772317

刷bios ，但是注意电压1.8v的需要注意。



17年之后大多是1.8v的IC，编程器要支持。V星都有jspi1接口在板刷，要不就是带一键U盘恢复的主板

**！！！ 查看bios芯片支持，去找接脚定义。**

查到对应芯片是要1.8V的，查芯片内容到淘宝上找。

![image-20220528105025431](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653706229/2022/05/00f5666596bd1daa3cf3bad42a7f985c.webp)

![](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653706229/2022/05/00f5666596bd1daa3cf3bad42a7f985c.webp)

![image-20220529182908578](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653820154/2022/05/2fa25b0876f334c1b33b9f5b3091cdbd.png)

SPI也要小心主板费。

https://www.chiphell.com/forum.php?mod=viewthread&tid=512473&mobile=1



https://www.its203.com/article/ClownFeilong/105256488



http://diybcq.com/thread-144131-1-1.html  ch341a 编程

https://manuals.plus/zh-CN/eeprom/ch341a-24-25-series-flash-bios-usb-programmer-manual    ch341a操作手册



【方法二】
现在许多一线厂商主板都支持BIOS刷坏后自动通过检测U盘里是否存在BIOS文件来自动回复BIOS，
华硕、微星都支持这个功能，将BIOS文件下载到U盘里，插在刷坏BIOS的主板上，

只要主板BIOS引导区还存在，主板启动键盘LED灯闪亮，光驱LED灯闪亮，U盘LED灯闪亮，都可
间接证明BIOS引导区还存在，那么BIOS引导区就可以自动搜寻外设装置里的BIOS文件

，做恢复尝试。华硕主板需要将BIOS文件名改为主板型号相应的文件名，才可以自动刷新。
微星主板则统一将BIOS文件更名为"AMIBOOT.ROM"（不包括""），Copy到U盘的根目录下

，将U盘出入USB接口（U盘中z好只有AMIBOOT.ROM一个文件），开机，按Ctrl+Home键强制
系统刷写U盘中的BIOS文件，U盘灯闪烁一会儿后，系统会自动重新启动，这样一切又恢复

正常了！

![image-20220528181506951](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653732911/2022/05/7aebfcb7fee91e6d421dd23d7f3779b1.webp)

 图3的界面里如果扫描出有BIOS更新，请大家慎重安装。我的两次情况都是在这里点击安装以后，主板上的CPU故障灯一直亮，然后Windows 10系统就无法启动了（BIOS都出问题了，没有引导程序，系统当然不会启动了），第一次遇到的时候有点慌，毕竟是自己手欠，不在保修范围里的。之后查阅大量相关的文章后，我知道了可以通过背板上的 FLASH BIOS BUTTON 按钮进行硬刷 BIOS 。 作者：Constantinex https://www.bilibili.com/read/cv12256251 出处：bilibili

------------------------------------------------------------------------------------

回家就是联想主板配置openwrt。

这个x370的主板如果还是proxmox报错软中断的话，那就windows，然后作为开发机器使用。v2k2 作为server使用，hyperv下装openwrt，然后配置。

![image-20220529075428159](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653782070/2022/05/df2f418f7dfd596b93ba70b8de4e5df4.webp)

既然上面已经有SPI各个脚的标注，和编程器怎么连，连接几个脚就要问编程器了。

芯片和SPI线柱的连接我己经用万用表找到了，只等测试了。估计51%会成功。


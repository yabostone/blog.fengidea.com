---
title: "Unraid安装过程"
date: 2022-03-30T08:04:56+08:00
tags:
  - 闲鱼	
categories:
  - 运维
draft: false
---



# Unraid 6.9.2 开心版安装和汉化教程

------

最近想搞台All in one主机，看了下阿文菌的文章，发现他文中提到的硬件都涨价了，还是做等等党吧，先用之前的J1900主机玩一下系统，Unraid还是比较好用的。

首先准备一个U盘，格式化成FAT32格式（如果U盘过大没有这个选项就用diskgenius格式化），然后重命名U盘名称为UNRAID。
[![img](https://s2.loli.net/2022/03/31/e2UHN8msoDbn9Vq.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_143142.jpg)

接着下载需要的文件：https://d6.cx/s/1Nub

把文件解压，全部复制到U盘根目录。

管理员身份运行U盘里的UnraidTool.exe，选择U盘，然后点击设置U盘启动
[![img](https://s2.loli.net/2022/03/31/SETPReC5BbNUQkF.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_143708.jpg)

会弹出窗口，是否UEFI启动，我们输入N回车，然后一路按任意键，最后关闭窗口。

[![img](https://s2.loli.net/2022/03/31/ELcg1h59OdbDSJe.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_143801.jpg)

然后点注册KEY，点确定。

[![img](https://s2.loli.net/2022/03/31/L3sR7ghjWp4D9mV.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_143822.jpg)

接着就可以拔掉U盘去需要安装的主机上插U盘设置U盘启动来开机了。

开机后会自动选择第一个进入，不需要动。
[![img](https://s2.loli.net/2022/03/31/1JQPaYN4dowD5OK.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/de069be7fbc9c5c8bba54766369f7e3.jpg)

到这一步就说明启动成功了。其中IPv4那里是获取的IP地址

[![img](https://s2.loli.net/2022/03/31/iNAsGykgeZ24LpO.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/355e6060408bee83438ca0da24cac01.jpg)

我们返回到电脑上，输入刚才的IP地址进行登录。

登录后我们来汉化，点击Tools/Language
输入

https://gitee.com/ouiae/language-templates/raw/master/limetech/lang-zh_CN.xml

点击install 然后耐心等待。
[![img](https://s2.loli.net/2022/03/31/kbSBIWDpzaNHXuq.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_142422.jpg)

安装完成。

[![img](https://s2.loli.net/2022/03/31/htkpE5OoidbN7DA.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_141805.jpg)

然后我们去SETTINGS/DisplaySettings 设置简体中文 然后保存即可

[![img](https://s2.loli.net/2022/03/31/5oLm34GjPJVBUEf.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_145233.jpg)

教程就到这了，其他东西以后再写。最后去创建阵列玩耍吧。

[![img](https://s2.loli.net/2022/03/31/nLOYqfkDa49MGZi.jpg)](http://www.dwf135.cn/wp-content/uploads/2021/05/2021-05-31_145443.jpg)
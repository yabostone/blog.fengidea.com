---
title: "SoftEtherVPN的自用配置"
date: 2022-06-13T12:03:16+08:00
draft: false
---

== 测试了下SoftEther。

## 简介

本地希望能有个wg外的备份方案。SoftEther的操作比较方便。

## openvpn

SoftEther连接后，注意到Hub项，务必加上SourceNAT和DHCP，不然自己分配比较麻烦。

然后记得hub中添加用户和密码，测试IPsec和openvpn端口打开可以用，sstp由于和443端口冲突，不适用。

![image-20220613120520604](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655093124/2022/06/b9c3f2c3f3e735beb176f7b310946283.webp)

openVPN下载的opvn文件需要修改协议到tcp，同时更改默认的访问IP或者域名。端口情况变化。

### route表

如果不添加默认的路由和dns，就是客户端推送那里。默认就没有修改dns和网关，需要配置的就是使用route表手动添加和删除，如果添加了默认是全局路由。

![image-20220613120851120](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655093335/2022/06/fdbe968bb1afa8a5a38dc4a48b165c0a.webp)

由于国内的政策，没法使用路由自动分发，SoftEther自动禁止了，需要自己手动添加route表。并且自动调整dns。

## IPsec

默认全部中转到服务器上，适合临时救场和使用。



## 更新

可以直接用用openVPN server，这样可以推送配置。。。

![image-20220613121914727](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655093958/2022/06/2bed5469ed064b59271904f3ffb34ddd.webp)

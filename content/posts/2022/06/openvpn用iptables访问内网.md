---
title: "Openvpn用iptables访问内网"
date: 2022-06-15T10:03:45+08:00
draft: false
---

==

使用iptables在openwrt上设置转发。

![image-20220615100434955](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655258678/2022/06/559ee05a1328919cae2a63ed15a872b0.webp)

![image-20220615100453944](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655258695/2022/06/475c13a2222a528d9b0a208c232a9996.webp)

所有目的地为1194端口的	都接受，

然后在tun0（查看ip a）处和l0处的都是选择接受，lo是用来bypass等的转发的。

最后做SNAT，源地址nat，将192.168.196.0的地址的数据包的源地址转为内网地址进行转发。


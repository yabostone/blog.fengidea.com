---
title: "Zerotier异地组网特性"
date: 2022-05-26T14:08:50+08:00
draft: false
---

 介绍zerotier异地的nat环境下的特点

## zerotier 异地

用移动网测试了异地情况。

zerotier和wireguard的不同，zerotier是用端口作为握手和开端口的连接点。实际开出的端口可是另外的高位端口。

wireguard是将所有的流量全部走endpoint？**可能也是打洞**，应该不是打洞？毕竟要用udp2raw。

就是zerotier流量不稳，因为通过中心服务器进行ip发现。还有第一个包的中转。wireguard比较稳定，https://icloudnative.io/posts/wireguard-docs-practice/

![image-20220526145636491](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653548200/2022/05/ac7990b89e4923fb4160f292d857b7ae.webp)

1.moons的添加需要两边orbit moons-id moons-id

2.可能需要重启

3.机子上看listpeers，如果有端口，那就是可能可以直连的，如果没有显示，也可能是长时间未连接，没有保活而不显示，实际上还是可以通过moon和endpoint连接的。

4.如果没显示endpoint，说明这台机没法直接访问，也不会通过根服务器中转。但是可以通过moon中转，前提是配置相关moons

5.注意，好像zerotier不用dmz也可以。

6.

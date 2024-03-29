---
title: "SDLAN的第二弹"
date: 2022-08-13T21:11:40+08:00
draft: false
---



#### 牛客秋季活动第四天

前天我们讨论了常用的用来搭建SDLAN的方式，在一些特殊场景如餐饮店的异地组网，家用访问家里的私人影院等都可以起到良好的效果，当然可能遇到运营商的一些Qos和丢包，部分我们需要使用一些规避的方式，这里先跳过。



自己主要是使用Tailscale作为单一节点访问的方式，因为Tailscale在使用便捷性上有很大的优势，接着在判断用户访问属性ACL上面，有一定的限制，没法将没有安装tailscale的主机作为客户端。

#### TailScale

是在Wireguard上面的一种改版，增加了NAT回退，打洞，生日算法等等方式尽力满足从nat1到nat3和nat4的打洞关系。

经过测试nat3到nat4的直连尝试打洞时间不固定，30秒到数分钟都可能，而且支持ipv6，目前本地看ipv6的选路和路由更好些，延迟也更低。

如果是nat3以上互联，中转转到直连速度也更快些。但是需要注意到配置中更改端口，默认的端口会被运营商中断。

这个和自己的路由和运营商有关，默认的三大运营商在路由能够配置Full ConeNAT的情况下可以快速连接的。



#### WireGuard

但是目前我使用SDLAN的使用的是wg，一方面我将两边的路由都设置到openwrt上的内核5.6版本以上，默认自带了。

然后配置luci使得能够使用Wireguard，我们在学习Wireguard的时候最好先用linux默认配置相关的环境和iptables。方便了解相关的配置和流程。（需要网络相关知识。）

这边通过定时任务判断网络连接可用性，两边均有ipv6，一边的ipv6做ddns，设置到cloudflare，另一边指定dns为dnspod(目前测试dns更新cloudflare方的国内ip更新速度最快)。长时间keepalive会导致多丢包。所以设定定时任务3天端口重连一次。另外每分钟ping，一旦两次无法ping通就重启端口。注意，只有重启端口才能刷新ddns的域名值，默认wg连接方式为ip，不能动态更新。

###### udp的Qos

部分运营商会设置Qos，一旦持续连接时间长，中间的链路运营商路由交换可能发生中断，这里我们需要用udp2raw或者phantun进行流量混淆。



#### 为什么不用zerotier

一方面和wireguard的路由表冲突，也和tailscale路由表冲突。另外一方面几乎大多数的运营商都会对zerotier的数据包进行严重的qos，也会对zerotier的root节点也就是打洞要用的节点需要的数据进行阻断，效果这几年一直不佳，包括nat打洞的效率也是，经历过3个多小时才打洞成功的案例。而且好像zerotier发包的端口是不固定的，无法通过流量混淆的软件，当然也许用moon节点进行中转或者nat是可行的，没有尝试。



#### 推荐可选方案

Nebula还是不错的可选方案，lighthouse 不中转只握手，而且可以控制网段的连接，没有使用主要是考虑到openwrt还是没有相关的包和依赖，这样在已有高度可控的wireguard方案相比，暂时列为可选方案，毕竟互相访问需要另设linux配置好路由和路由的转发，异地路由的相互转发和路由表。


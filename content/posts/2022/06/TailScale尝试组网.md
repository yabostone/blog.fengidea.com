---
title: "TailScale尝试组网"
date: 2022-06-15T12:14:46+08:00
draft: false
---

== 尝试tailscale

tailscale的内网段只能使用要求的一个网段，通过route add 添加无效，tailscale的网段会阻止转发，

！！！ 但是每个devices都能使用一个网段，通过多个设备可以访问多个网段。。。我靠了。

# 注意

#### tailscale 默认端口被屏蔽

注意，默认端口41641是被屏蔽的，需要更换端口，**可以用端口转发udp，只要保证相同的端口号就可以。**



可以在tailscale上的路由处，连接tailscale后指定ip访问远程路由。



在openwrt上，或者linux下，iptables加鉴权判断，没有添加route表。

在openwrt下，只能使用LAN口对应的内网网段，无法使用wan口的网段，不会进行wan口的192.168.0.0/24 的转发。

！！！！ 可以将**tailscale作为临时访问openwrt进行**应急救援的连接方式，等同于todesk和向日葵。

### 基础要求

1.需要是vm，不是lxc，因为需要内核开接口。

2.这里用的alpine，需要开启ip转发。ip_forwarding。

3.默认路由是开启upnp的路由，开启到wan口。

4.upnp默认是开启100个连接，openwrt的而且会快速失效，需要将保存时间延长。



!!!!

## 修改默认端口

```Bash
[Service]
EnvironmentFile=/etc/default/tailscaled
ExecStartPre=/usr/sbin/tailscaled --cleanup
ExecStart=/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port $PORT $FLAGS
ExecStopPost=/usr/sbin/tailscaled --cleanup
```

环境变量在 /etc/default/tailscaled  中修改默认端口。



## 直连步骤

#### 简单说明

1. 配置Upnp
2. 配置默认路由到支持Upnp和PMP等的路由上，可能路由不支持，需要注意，如zte不支持。openwrt需要检查开启Upnp
3. 使用 tailscale netcheck 检查是否支持Upnp。
4. 需要重启tailscale 使能添加upnp，（好像非必须）
5. 需要在支持upnp的**一方去ping 对应节点**，使得能够通告ip和port，连接成功后一次后需要持续ping，否则到idle再不连接后对方nat4端口会变化。
6. 如果没有重复ping，直连会中断，下一次就很麻烦。（仅针对upnp的转发端口和tailscale通告端口不一致的情况。）如果是自定义端口，并且用upnp打开，并且port号一致，那么用带upnp的一样ping节点就可以了。

### 连接步骤

1. 两方必须有一方支持upnp，这样能快速连接，同时修改tailscale默认端口。（没有尝试修改默认端口，加上路由定向转发的方式）

2. tailscale netcheck 检查upnp支持，
3. 重启添加upnp。
4. 有upnp的一方去ping 对应节点，使通告port，连接成功后持续ping。否则会连接失败。（如果通告port和wanport一致，那么可以直连）
5. 上述仍然可能失败，无法直连。原因（变更网络后，之前的upnp占用了相同端口，如42000，重启后端口号upnp添加为42001，增加复杂度）（必要时删除upnp的占用端口和删除默认添加的upnp端口）。



------------------------------

以下是记录：



### 端口直连

公司网络的路由可以自己配置，且有upnp。

1.UPNP需要是默认的路由，直接打开的是默认的路由的端口，

#### TailScale Keepalived

似乎一定时间后就会停止keep，表现为之前可以直连的，暂时无法访问， 这里端口没有变化，也可能是修改了端口导致不能访问，因为这里会出现无法访问的是固定了端口。

#### nat3 和nat4

一边网络是nat3，一边网络是nat4+，就无法直连。有时候可以连，可能是生日算法吧，看到Upnp开启了41642的端口。然后用的tailscale ping 调试成功的。玄学。（调试成功的一次是windows断开后重连）

!!! 注意，成功后变成IDLE后，再次连接就变成中转了。没有发送心跳包！！！

![image-20220615213320901](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655300005/2022/06/339268a85e0ca2bdee93aad9eb5908d3.webp)

### UPNP案例

192.168.36.0

![image-20220615170336220](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655283818/2022/06/eceacaee865c4364b6fa81b5f12088d7.webp)

+ Upnp会探查Upnp外网IP的对应端口知否被占用，这里的41641之前被op-36-main的端口占用了。所以自动后移一位。

+ 两层Upnp之间是不能穿透访问的，这张图是第二级路由，只能开放wan口的192.168.0.21端口的41642。
+ Upnp有时候开了端口，然后还是relay。。
+ 倾向于直接固定端口。在有能力开端口的情况下还是开端口比较好。**端口号需要一致**
+ 没有设置端口转发，没有设置upnp，但是直连了，可能是直接默认全局端口的解决的。

![image-20220615171405716](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655284448/2022/06/06f831da422dcaf24357dd78c921a31b.webp)

从这里看出，二层路由将为NAT3，哪怕开启了两个路由的NAT1和Upnp，然后由于设置了分流bypass，在连接外网的stun或者服务器时候，表现为FULL CONE，但是这里没法设置wg，因为端口变化？

#### 特殊连接

x230在nat4下，dsm没法连接，但是ping x230 直连，推断是由于有一个网口是直连，所以通过ipv4接口直连。

### 修改默认端口

![image-20220615174207987](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655286131/2022/06/8cee3d2001926cfb42726791aa75d7df.webp)

+ 在/etc/init.d/tailscale 文件下，将41641修改成42000端口，
+ 再rc-service tailscale restart 即可。

Openwrt下，/etc/config/tailscale 可以修改默认的端口。



### 防火墙

从内向外指定端口，用socat，用端口转发。

数据从外向内流向，指定用端口转发。

![image-20220616113500821](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655350505/2022/06/f29aa6b731014b83ed61ca06374bbd90.webp)



![image-20220616141910305](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655360354/2022/06/5675578262bcb6931d71a77d312fd502.webp)

![image-20220617132510893](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655443514/2022/06/f4cce121bbd8abf30aa2300856698d5d.webp)

+ 联通？上海联通时常有 但也不是一直有，不知道触发的模式.
  之前用的是 Wireguard 和 Anyconnect 这种 UDP 的 VPN ，
  另外最近 Wireguard 算是完了 前一天用 第二天就端口封掉了

# 网络占用和消耗

发现占用资源比较多，在内网环境下，接近1/3的损耗，从36.1 到0.1的网段，几乎打满，这就是两个客户端分别网段的弊端。！！！结果36.1到0.1完全没有用到tailscale，瞎操心了。就是单纯的流量上下。

回去后使用wireguard组网，需要注意，tailscale作为备份使用咯。

![image-20220719215401463](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658238844/2022/07/13bf825717a90e1acc9f1c2e7ea6d274.webp)

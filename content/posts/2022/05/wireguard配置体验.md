---
title: "Wireguard配置体验"
date: 2022-05-22T16:02:04+08:00
draft: false
---

用来异地组网，可能要用udp2raw。

!!! Allowed_ip 添加 172.20.0.0/24网段，只添加/32 网段无法访问，24网段是作为路由要求放入的。

！！！ 更改端口的方式

----------------------



我现在的解决办法，用当天的日期xx做端口号末尾两位，比如`50xx`，用着还行

### 服务器

```
# cron
1 0 * * * sudo wg set kr listen-port 50$(date +\%d)
# /etc/sudoers.d/sudoer
al      ALL=(ALL)       NOPASSWD: /usr/bin/wg
```

### 客户端

```
wg-quick down kr
# wg set 会去掉 DNS，所以直接编辑配置文件
sudo sed -i /Endpoint/s/:50.*/:50$(date +%d)/ /etc/wireguard/kr.conf
wg-quick up kr
```

---------------------





 **systemctl reload wg-quick@wg0.service**

修改配置后一定要用reload，用restart和stop方式没有用。

支持域名。

要用enable 来自动启动。

**systemctl enable wg-quick@wg0**



- 国内互联互通，其实是对VPN不拦截的。特征明显，但不敏感。



> 1. PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> 2. PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

去掉最后面的MASQ的nat，将所有的入站wg0的和出站wg0的端口放开

#### moon连接不上

+ 简介：自己想建立一个，稳定，安全的组网环境，之前有用zerotier，并且自己搭建了moon，但有时候也会存在链接不上情况，毕竟服务器是是他们三方搭建的，而且在国外，安全和稳定性都不靠谱，所以只有自己搭建一套组网环境，才是最可靠的

+ 我们这里的联通把所有 zerotier 的数据包都丢了，电信，移动，不需要 moon 秒连。



##### iptables设置

- `PostUp` 是当前网卡启动后进行的操作，可以是任何 Linux 命令，多条指令用 `;` 分隔。这里我们写了三条：

  - `iptables -A FORWARD -i %i -j ACCEPT` 在 iptables 的 filter 表 FORWARD 链上追加一条规则，对来自 `%i`（即 `wg0` 网卡）的数据包采用 ACCEPT 的策略。

  - `iptables -A FORWARD -o %i -j ACCEPT` 在 iptables 的 filter 表 FORWARD 链上追加一条规则，对去向 `%i`（即 `wg0` 网卡）的数据包采用 ACCEPT 的策略。

  - ```
    iptables -t nat -A POSTROUTING -o <SOME NET INTERFACE> -j MASQUERADE
    ```

     https://naiv.fun/Ops/53.html

    在 iptables 的 nat 表 POSTROUTING 链上追加一条规则，对去向某网卡的数据包采用 MASQUERADE 的策略。MASQUERADE 是一种特殊的 SNAT（基于源地址的网络地址转换），在这个例子中的作用为，将发出的数据包的源地址改为某网卡的 IP 地址。

    需要注意的是，这里的 **某网卡** 一般要填写连接公网的网卡，例如 `eth0`。具体的原理解释可参考：[使用 iptables 配置 NAT - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/42153839)



```Bash
iptables -A FORWARD -i vpn0 -j ACCEPT
iptables -A FORWARD -o vpn0 -j ACCEPT
```

这个允许所有端口

![image-20220522201256707](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653221579/2022/05/a10f1c0facd3798122a37aaf57be5717.webp)

watchchat 

自动检测目标是否可用，不可用就重启实例，和ddns连用。

配置转发

https://ggqshr.github.io/2020-12-21/wireGuard%E5%AE%89%E8%A3%85%E5%92%8C%E9%85%8D%E7%BD%AE%E8%BF%87%E7%A8%8B/

这个写的还好点。

iptables的介绍

https://www.zsythink.net/archives/1517

## 需要注意

这里搞了一个下午加晚上，获取了这些信息。

### 客户端和服务端

虽然是对等，由于有些没有公网ip，或者说不能双向直接访问，需要中转。这时候，**只能没有外网端口暴露的客户端先连接有公网ip的服务端，连接成功后**，才能在服务端访问客户端，这个时候需要用keepallive保活。（**客户端即没有公网ip的一定要设置保活）**

此时，两边的wg 命令显示的的endpoint两边都是一样的，不管真正ip是在哪边。

这个图片是客户端（没有公网ip的客户端）的配置成功图片，用PersistKeepalive 保活。endpoint指服务端的endpoint，可以是内网地址，

![image-20220522223645197](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653230208/2022/05/26c22829968d4cff6124cdf85685079b.webp)

这个图片 是服务端，要注意的是，endpoint可以不写，因为对面的peer没有公网endpoint，写的话写对面peer的内网。也可以写keepalive，没事。

![image-20220522223834735](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653230316/2022/05/64208a55c9247c2a1985bd81d8732f29.webp)

注意此时两边的wg都是相同的endpoint，表明**连接通道是endpoint**。

### 公钥私钥

两个peer的**私钥不能相同**，否则不显示。

##  路由配置

### 接受入站

就是开启wan口到内部op路由的端口的转发，默认op的端口不向wan口开放（ping错了，还是两边不能访问）（原因是端口写错，所以后面用nmap查端口。。。）

#### 路由出站

![image-20220522225755495](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653231477/2022/05/bb9d53805f896cc355057ca6b9fc3c33.webp)

ping wg外没法访问。

![image-20220522230805370](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653232088/2022/05/71cf587bc8df9724b55fc0fef235603b.webp)

！！！！ **端口配置错误！！！ 58120和51820！！！**

端口转发和通信规则可以不用配。。。

![image-20220522231437627](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653232479/2022/05/d89fb861ae6a3069031e7103314aa4aa.webp)

![image-20220522231456420](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653232499/2022/05/73ac8e27888749ca7da8820388645c24.webp)

**务必注意，需要重启防火墙，原因不明确。**

### 变更配置

**任何一边变更配置，都可能要两边重启wg，op可能还要重启防火墙。**



###### %i 的语法

http://kaige.org/2019/07/24/iptables/



## LAN to LAN SDLAN

wireguard节点，配置两个wg0-wg1，分配连不同网段？？

还是一个wg0 ，添加静态路由表。

感觉都不对，

#### 互通性

在配置LAN1和LAN2时候，两个Peer都是和服务器连接的，这个时候两个是不互通的。172.20.0.10 和 172.20.0.1 互通，172.20.0.20 和172.20.0.1互通， 10和20的机子不互通。因为没有加上peer允许。

需要在AllowedIPs 上单独加上172.20.0.0/24 的网段。这里的wg0加上了MASQ。可以不加172.20.0.1 定向，第三个将他覆盖了，允许的ip表示路由表和下一跳走的peers，peers的ip由对面的（或者通道的endpoint）进行传递数据。



![image-20220523094716273](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653270439/2022/05/914e62ab417f790d73d46b59267f3a42.webp)

![image-20220523094859448](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653270542/2022/05/54d6d488ea9e053e94fe4f799b335be9.webp)

## ip变化ddns

但这里有一个小瑕疵，WireGuard 只会在**启动时解析配置文件中域名的 IP 地址，**后续如果域名对应的 IP 地址有更新，也不会重新解析。！！！！

![image-20220523085831473](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653267514/2022/05/ecdcd511f3991a6d02b96abe547578fc.webp)

https://icloudnative.io/posts/configure-wireguard-using-wg-gen-web/#%E5%8A%A8%E6%80%81-ip

#### 脚本配置成服务并设置timer定时

![image-20220523090040388](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653267644/2022/05/9dafd5c73289ed2855ef9c713e6bfbe8.webp)

https://icloudnative.io/posts/configure-wireguard-using-wg-gen-web/#%E5%8A%A8%E6%80%81-ip



https://github.com/jwhited/wgsd 提供coredns的udp打洞，，为什么不用zerotier？？



#### ip6tables更新

```Bash
[root@vm_ci01 ~]# more /etc/wireguard/wg0.conf 
[Interface]
PrivateKey = [填入私钥]
Address = 10.253.0.3/32
ListenPort = 50004
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i %i -j ACCEPT; ip6tables -A FORWARD -o %i -j ACCEPT; ip6tables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i %i -j ACCEPT; ip6tables -D FORWARD -o %i -j ACCEPT; ip6tables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

[Peer]
PublicKey = [填入服务端的公钥]
AllowedIPs = 10.253.0.0/24,192.168.116.0/24
Endpoint = 1.123.45.67:50004(服务端的IP端口)
PersistentKeepalive = 25

```

## iptables更新

只要在server端口上，作为中转的wg0需要更新iptables，加上masq，两边的op是不用加的，模拟了路由的功能，server模拟路由功能时候需要加上masq。如果wg在op上只是作为client，直接route转发就可以了。

AllowedIPs相当于配置route。



## 测试ipv6

两边都可以改endpoint，但是要添加自动重启服务，op上。

ipv6需要在Address上面进行额外更新。

https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-22-04

### op 修改iptables 

应用方式，LAN口也可以是带v6的。

！！！ 多个endpoint只能一个，所以只能在v4和v6下选择，zerotier倒是可以v4和v6都作为moon。

所以其他网段连接，需要配置的话，两边都是nat就v6.

这个网段只能v4，18.1默认是在v4环境，没有v6环境。

## 重启脚本

```Bash
#!/bin/bash
ifdown vpn0
ifup vpn0
/etc/init.d/firewall restart
```

server端还是用脚本重启，因为使用域名，至少有1分钟不能访问，这个时候直接重启是没有问题的。

```Bash
    def update_wireguard(self):
        t1 = subprocess.getstatusoutput("systemctl stop wg-quick@wg0.service")
        print(t1)
        t2 = subprocess.getstatusoutput("systemctl stop wg-quick@wg0.service")
        print(t2)
        
```

注意wg0文件需要不设置saveconfig，因为配置文件会发生变化。dns会解析。

#### 重启建立时间



重启后重新建立连接需要40秒，此时两个网段的ip包不可访问，如果是wg上的172。20网段好像速度快些。

### 用wireguard 可以连接完全内网的vps

可以选用仅ipv6的vps和natvps和完全内网的vps了。

## 连接服务器端的网段

![image-20220525203627749](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653482190/2022/05/fb10aa50e7a7c53ae0c03cd12bf9a568.webp)

前两个配置所有wg0的端口都可以通过iptables。

后一个eth0是指向外网或者wireguard所在的网段或者上一级网段。添加masq可以让其他的客户端访问192.168.0.0网段**（interface所在网段和上级路由所在网段）**

如果要让vmware下的路由能访问本机所在的网段，添加allowedIPs，添加iptables将上级路由所在端口转为masq方式访问。

![image-20220525205157254](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653483119/2022/05/a0a05a6eafa6a9dd9d86db8234bc5e06.webp)

## QOS

说明各地都是有qos，所以还是要套udp2raw。或者用tinc。

![image-20220526092527717](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653528330/2022/05/c096183501835ea0cd975157abf2102a.webp)

国外回家吗？
国内使用，普通 vpn 完全没有问题

 不是，就是单纯同城回家里内网，其实单看流量进出比例也知道我这不是过墙梯啊，不明白为啥一直被干扰

udp 的 qos 很难受，尤其跨运营商。

wireguard，广东移动，如果作为客户端去连另一台广东电信的，一开始是通的，一段时间后就断了，重启 wg 也不通，需要关掉隔很久在开才通，如果做服务端，frp 出去就很正常

哪的网这么坑啊，太原电信很好，微信找客服报障说要公网 IP，宽带账号发过去五分钟完事，v4v6 双公网，端口就封了个 80/443/8080，VPN 管都不管，L2tp 好好的。openwrt 跑俩 DDNS 再加上 SoftetherVPN，在配上 Zerotier 备用，远程桌面什么的搞个网络唤醒+端口转发，稳如老狗。



我也是尝试过各种方案，现在稳定用了一年的方案是 softether 双协议，电脑用 softether，手机连 openvpn，高位端口

我也发现这个问题，v2rayNG/SSR 和 zerotier 不能同时打开，好在很少远程需要回家



ipv6 很好用, 北京电信

- zerotier 这公司还真牛逼，在北上广偷偷建立各种高速节点，这勤奋程度比很多机场都要强。

zerotier 经常出现打洞失败的情况，换成 WireGuard 了。

**印象中移动宽带已经封了 wireguard**

国内用 vpn 没有跨境的话，不至于那么容易出问题吧，喝茶又从何谈起。别干不该干的，低调一点，不会有任何问题。王静没那么多闲工夫。
vpn 只是一项技术，真要一刀切政治不正确，1194 之类的端口早就被运营商封了。openvpn 协议 l2tp 协议早就被拦了。

###### udp2raw不支持域名

需要自己解析ip。

如果udp没有问题的话，那么op和wg也是没有问题的呀。

wireguard 可以套 udp2raw ，我就是这样骗过 gfw ，单独 wg 不稳定，偶尔能过墙，大多数不行，套上 udp2raw 很稳。

![image-20220526150053126](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653548456/2022/05/fc16e016ae4786b65ee151a68157bb47.webp)

##### wireguard部分用法

### 奇技淫巧

#### 共享一个 peers.conf 文件

介绍一个秘密功能，可以简化 WireGuard 的配置工作。如果某个 `peer` 的公钥与本地接口的私钥能够配对，那么 WireGuard 会忽略该 `peer`。利用这个特性，我们可以在所有节点上共用同一个 peer 列表，每个节点只需要单独定义一个 `[Interface]` 就行了，即使列表中有本节点，也会被忽略。具体方式如下：

- 每个对等节点（peer）都有一个单独的 `/etc/wireguard/wg0.conf` 文件，只包含 `[Interface]` 部分的配置。
- 每个对等节点（peer）共用同一个 `/etc/wireguard/peers.conf` 文件，其中包含了所有的 peer。
- Wg0.conf 文件中需要配置一个 PostUp 钩子，内容为 `PostUp = wg addconf /etc/wireguard/peers.conf`。

关于 `peers.conf` 的共享方式有很多种，你可以通过 `ansible` 这样的工具来分发，可以使用 `Dropbox` 之类的网盘来同步，当然也可以使用 `ceph` 这种分布式文件系统来将其挂载到不同的节点上。

#### 从文件或命令输出中读取配置

WireGuard 也可以从任意命令的输出或文件中读取内容来修改配置的值，利用这个特性可以方便管理密钥，例如可以在运行时从 `Kubernetes Secrets` 或 `AWS KMS` 等第三方服务读取密钥。

### 容器化

WireGuard 也可以跑在容器中，最简单的方式是使用 `--privileged` 和 `--cap-add=all` 参数，让容器可以加载内核模块。

你可以让 WireGuard 跑在容器中，向宿主机暴露一个网络接口；也可以让 WireGuard 运行在宿主机中，向特定的容器暴露一个接口。

下面给出一个具体的示例，本示例中的 `vpn_test` 容器通过 WireGuard 中继服务器来路由所有流量。本示例中给出的容器配置是 `docker-compose` 的配置文件格式。

中继服务器容器配置：

**从可以用docker上看wg是只使用一个端口的。**

![image-20220526150718036](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653548840/2022/05/fe98d99b54751a8fcfb17e3faa862c04.webp)

狗云的价格好像15元之内都还好。

## wireguard 配置一个带路由的peer

```Bash
iptables -A FORWARD -i vpn0 -j ACCEPT
iptables -A FORWARD -o vpn0 -j ACCEPT
iptables -t nat -A POSTROUTING -o vpn0 -j MASQUERADE
iptables -t nat -D POSTROUTING -o wan -j MASQUERADE
```

添加防火墙到openwrt上面。

+ 联通？上海联通时常有 但也不是一直有，不知道触发的模式.
  之前用的是 Wireguard 和 Anyconnect 这种 UDP 的 VPN ，
  另外最近 Wireguard 算是完了 前一天用 第二天就端口封掉了

## wireguard联通在openwrt下

**主节点务必加上SNAT,将所有通信更改源ip到192.168.0.2上。**

```
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -j SNAT --to-source 192.168.0.2

```


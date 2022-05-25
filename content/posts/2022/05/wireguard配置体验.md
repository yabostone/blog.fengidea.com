---
title: "Wireguard配置体验"
date: 2022-05-22T16:02:04+08:00
draft: false
---

用来异地组网，可能要用udp2raw。

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


---
title: "Phantun和udp2raw测试使用"
date: 2022-05-27T08:24:04+08:00
draft: false
---

udp2raw 的替代品，

自己用udp2raw总是不成功。（更新，终于成功，也不需要改iptables）

phantun也成功了，只需要用udpping测试

![image-20220527140330045](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653631413/2022/05/0ad147ca60c9bfce3d095c07a1bec658.webp)

![image-20220527140343797](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653631426/2022/05/061224902f414c9b54bbe5ec3436bac0.webp)

## udp2raw

```
udp2raw -s -l0.0.0.0:4096 -r 127.0.0.1:5201    -k "passwd" --raw-mode faketcp -a

udp2raw -c -l0.0.0.0:3333  -r192.168.0.13:4096  -k "passwd" --raw-mode faketcp -a

```



```
socat TCP-LISTEN:3333,fork TCP:192.168.0.13:5201
```

### 测试udp2raw 是否连通

#### server端

openwrt没有server端选项和client端选项，所以只能用命令行。

使用socate 创建一个可以ping的端口

```Bash
 socat -v UDP-LISTEN:4000,fork PIPE
```

用udp2raw进行端口转发,这里是server端的端口

```Bash
udp2raw -s -l0.0.0.0:4096 -r 127.0.0.1:4000    -k "passwd" --raw-mode faketcp -a
```

用udp2转发，client端口。

```Bash
udp2raw -c -l0.0.0.0:3333  -r192.168.0.13:4096  -k "passwd" --raw-mode faketcp -a
```

最后下载udpping

```Bash
wget https://raw.githubusercontent.com/wangyu-/UDPping/master/udpping.py
python3 udpping.py 127.0.0.1 4000
```

当显示client ready 说明建立通道成功。

**不需要额外设置iptables 用-a 命令。**然后一定要设置防火墙，socat上设定后还要再端口转发上设置允许wan转入。

**（socat只负责调整防火墙的转出，LANtoWAN的转发允许，不涉及wan口到内部端口的转发）**

### udp2raw设置

！！！！ 不能使用uci的写法,因为会强制刷新服务。server必须要用脚本形式。

client 端可以用界面，但是需要设置脚本更新server的ip地址。

server端用的脚本为

```Bash
#!/bin/sh /etc/rc.common
# Copyright (C) 2008-2012 OpenWrt.org

START=99
APP=udp2rawserver
SERVICE_WRITE_PID=1
SERVICE_DAEMONIZE=1

start() {
        service_start /usr/bin/udp2raw --conf-file /mnt/sda1/config/udp2raw/udp2raw.server.conf
}
stop() {
        service_stop /usr/bin/udp2raw --conf-file /mnt/sda1/config/udp2raw/udp2raw.server.conf
}

```

手动  `/etc/init.d/udp2rawserver start` 即可

#### server

**记得要将wan口转lan口的方向设置为允许。**

![image-20220527121629180](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653624992/2022/05/04277593905f859af8281b8271ddaeab.webp)

![image-20220527111457868](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653621300/2022/05/746ad2504f3c2de8fc521c7028615d29.webp)

![image-20220527111525670](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653621328/2022/05/d88a7f2ef9cfbebaeb0298857f9aae7c.webp)



```Bash
root@OpenWrt-6110:~# cat /mnt/sda1/udp2raw.server.conf
-s
-l 0.0.0.0:50000
-r 127.0.0.1:58000
--raw-mode faketcp
--key faketcp123456
--cipher-mode aes128cbc
--auth-mode md5
--retry-on-error
--disable-color
-a

```

### client

client 的不需要设置防火墙，设置各防火墙方向为允许即可。

```Bash
root@OpenWrt:~# cat /mnt/sda1/udp2raw.cfg034a8f.conf
# auto-generated config file from /etc/config/udp2raw
-c
-l 127.0.0.1:58000
-r 49.67.188.241:50000
--raw-mode faketcp
--key faketcp123456
--cipher-mode aes128cbc
--auth-mode md5
--retry-on-error
--disable-color
-a

```

![image-20220527111937231](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653621580/2022/05/05457868b22e72634cd547b8a899eb3e.webp)

## phantun

客户端用iptables  masq即可。

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```



服务端做一个dnat的路由，将对应4567的端口转发到tun0上面的ip，再由tun0转发出去。

```
iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 4567 -j DNAT --to-destination 192.168.201.2
ip6tables -t nat -A PREROUTING -p tcp -i eth0 --dport 4567 -j DNAT --to-destination fcc9::2
```



### Gists

考虑先用phantun替代。



RUST_LOG=info ./phantun_client --local 127.0.0.1:1234 --remote 192.168.0.13:4567

RUST_LOG=info ./phantun_server --local 4567 --remote 127.0.0.1:4000

python3 udpping.py 127.0.0.1 1234

iperf3 -u -c 127.0.0.1 -p 1234





说明客户端跟远程不通，可以在 `tun0` 和 `eth0` 上面 `tcpdump` 看看数据包有没有成功的发出去。也可以在 server 上面抓包看看有没有正确的收到包。

/sbin/iptables -t nat -A PREROUTING -p tcp -i eth0 –dport 4567 -j DNAT –to-destination 192.168.201.2

systemd 写法。

```Bash
[Unit]
Description=phantun service
After=network.target
StartLimitIntervalSec=0
#Before=xxx.service # Service that depends on Phantun
[Service]
Type=simple
Restart=always
RestartSec=1
User=nobody
Environment="RUST_LOG=info"
ExecStart=/usr/local/bin/phantun_client --local xxx.xxx.xxx.xxx:xxx --remote xxx.xxx.xxx.xxx:xxx

[Install]
WantedBy=multi-user.target
```

！！！！ 不能使用uci的写法,因为会强制刷新服务。server必须要用脚本形式。

client 端可以用界面，但是需要设置脚本更新server的ip地址。

！！！！ 在vmware 中的桥接网口，如果更换了wifi，或者更换了通道**，内部的网口会不通，需要重启**

---
title: "单公网ip运行proxmox虚拟机的思路"
date: 2022-05-30T10:03:24+08:00
draft: false
---

随着认知的加深，现在能够考虑proxmox装在虚拟机环境上了。

思路： proxmox安装，然后host机上配置wg，再创建一个不绑接口的网桥，设置lxc下的openwrt，wg设置将所有流量转发到host机上的wg。（可能要在host机上进行SNAT的端口转发，将所有wg上的流量转发到host上）

思路： 通过k3s的flannel配置wireguard协议或者其他协议，暴露端口转发。

### proxmox绑定mac

network 绑定mac，保持网卡名称不变化,network, enp3s0

```Bash
root@e5:~# vim /etc/systemd/network/10-onboard.link 
root@e5:~# cat  /etc/systemd/network/10-onboard.link 
[Match]
MACAddress= 00:e0:4c:4f:65:c4
[Link]
Name=enp7s0
root@e5:~# 
```


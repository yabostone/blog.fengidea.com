---
title: "Ddns Go在openwrt的配置与saltstack"
date: 2022-06-12T18:06:38+08:00
draft: false
---

==用来替代ddns的作用，配置config-file到/mnt/sda1/config/ddns-go/ddns-go-config.yaml



配置 /etc/init.d/ddns-go

```Bash
#!/bin/sh /etc/rc.common
# Copyright (C) 2008-2012 OpenWrt.org

START=99
APP=ddns-go
SERVICE_WRITE_PID=1
SERVICE_DAEMONIZE=1

start() {
        service_start /usr/bin/ddns-go -f 30 -c /mnt/sda1/config/ddns-go/ddns-go-config.yaml 
}
stop() {
        service_stop /usr/bin/ddns-go -f 30-c /mnt/sda1/config/ddns-go/ddns-go-config.yaml
}

```

## 如果使用saltstack

其实都是salt配置文件存储，然后指定os，再用file.managed模块和cmd.run模块执行脚本，然后再配置安装。

http://static.kancloud.cn/louis1986/saltstack/521789

参见第七章配置管理。

![image-20220612223445098](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655044489/2022/06/b593e572841b387c4adbb8bd16c8c88e.webp)

![image-20220612223509317](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655044511/2022/06/d4214c215993ebb93b02cf5e55848611.webp)

![image-20220612223531363](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655044534/2022/06/2d2aa6b64f9bc186175b4952b49f237e.webp)

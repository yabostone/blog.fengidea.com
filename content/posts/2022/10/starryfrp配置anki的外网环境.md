---
title: "Starryfrp配置anki的外网环境"
date: 2022-10-03T17:02:58+08:00
draft: false
---

## 前言

这里是之前只设置了内网的anki环境的后续内容。作为备忘和文档。。。

之前的anki是使用0.19的ip的设置的pm2 的启动项，为http模式，再配置了内网的0.13的环境，宝塔面板的https。

+ 测试starryfrp的tcp模式配置到宝塔的https端口，失败，ssl的证书不匹配。如果使用https的反代的话，可能要在每个的连接端口处配置证书。



### 基本配置

+ 目前这类的反代，均建议使用1年期的免费证书，手动上传证书，配置文件位置，然后再设置frpc的配置。

目前的frpc的设置如下。SSL证书使用的是dnspod的免费证书TrustAsia。

https://gofrp.org/docs/examples/https2http/

```
[gNsutQ4W]
privilege_mode = true
type = https
local_ip = 127.0.0.1
local_port = 27701
custom_domains = anki.pub.zops.tech
host_header_rewrite = anki.pub.zops.tech
use_encryption = true
use_compression = true
plugin = https2http
plugin_local_addr = 127.0.0.1:27701
plugin_crt_path = ./anki/anki.pub.zops.tech_bundle.crt
plugin_key_path = ./anki/anki.pub.zops.tech.key
## 注意配置plugin_crt_path 的路径
```

![image-20221003172936867](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1664789404/2022/10/0bc21c370a5d26ef42747466d9fa85d3.webp)

再配置pm2的命令。

```
pm2 start /usr/bin/frpc --name starryfrphttps -- -c /etc/frpc/frpc.ini
```

-- 命令后的就是接的命令的选项命令。

测试android的https的连接方式，测试通过。



###### 再配置windows下的环境。



1.输入代码 `358444159`，点击 ok。

2.配置可以是https的格式的。

![image-20221003174921680](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1664790562/2022/10/65530bf2e2ab2598568a8ce4eab723a4.webp)

测试通过,密码是emmmm。。？



#### 备注

主要是每个隧道对应一个服务，不要考虑通过宝塔来直接暴露节点。所以frp和宝塔基本在ssl部分冲突？(需要配置两层ssl。)




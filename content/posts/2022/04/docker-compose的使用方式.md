---
title: "Docker Compose的使用方式"
date: 2022-04-01T11:01:45+08:00
tags:
  - 运维
categories:
  - 运维
draft: false
---

### docker-compose

查阅了github上的链接，现在docker-compose想注册到docker 下面作为插件，但是没有完成，

还是用chmod +x 手动处理吧。



#### 生成虚拟机

```bash

```

##### 配置docker

```Bash
curl -sSL get.docker.com -o s.sh
sh s.sh

```

##### 安装docker-compose

```Bash
apt update -y && apt install wget git -y
wget https://github.com/docker/compose/releases/download/v2.4.0/docker-compose-linux-x86_64
chmod +x docker-compose-linux-x86_64

cp docker-compose-linux-x86_64 /usr/bin/docker-compose

```

```Bash
docker run -dit \
  --name ql \
  --hostname ql \
  --restart always \
  -p 5700:5700 \
  -v $PWD/ql/config:/ql/config \
  -v $PWD/ql/log:/ql/log \
  -v $PWD/ql/db:/ql/db \
  -v $PWD/ql/scripts:/ql/scripts \
  -v $PWD/ql/jbot:/ql/jbot \
  whyour/qinglong:latest

```


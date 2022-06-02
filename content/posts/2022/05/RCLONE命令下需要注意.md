---
title: "RCLONE命令下需要注意"
date: 2022-05-29T16:38:03+08:00
draft: false

---

在RCLONE 下命令行模式需要注意：

###### 永久环境变量

设置了 AWS_CA_BUNDLE 会导致在使用aws 的s3 的相关服务，如阿里云等的时候，会出现证书不符合，aws s3 的命名行倒是可以用。

需要 用 set AWS_CA_BUNDLE=

命令在cmd 环境下消除后才能访问。  rclone  ls config-server:config-server


---
title: "Nacos的dockers配置"
date: 2022-06-12T22:14:27+08:00
draft: false

---

==由于版本对应问题，无法适配最新的版本，mysql的数据库表有问题，所以需要回退到2.0.3版本，

注意 docker下面有v2.0.3和2.0.3，两者不同，不知道对应关系，还是用2.0.3.

2.0.3也是稳定版本。下载量也多。

配置docker，配置nacos,版本号强制为2.0.3

~/nacos-docker/example# docker-compose -f standalone-mysql-8.yaml up -d

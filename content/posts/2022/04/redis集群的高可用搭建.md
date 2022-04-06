---
title: "Redis集群的高可用搭建"
date: 2022-04-05T14:12:00+08:00
draft: false
tags:
  - redis
categories:
  - 运维
---

#### Snippets

但这里分配槽只用了3个节点，其它3个节点就是用于主从复制的，保证主节点出现故障时可以进行故障转移，从节点负责复制主节点槽信息和相关数据。可以用以下命令让一个节点变成从节点(该命令一定要在从节点客户端上执行)。

redis 的springboot  https://cloud.tencent.com/developer/article/1894341

每个 Redis 集群节点都需要两个开放的 TCP 连接：一个用于为客户端提供服务的 Redis TCP 端口，例如 6379，另一个称为集群总线端口的端口。默认情况下，集群总线端口设置为数据端口加10000（如16379）；但是，您可以在`cluster-port`配置中覆盖它。

请注意，要使 Redis 集群正常工作，您需要对每个节点：

1. 用于与客户端通信的普通客户端通信端口（通常为 6379）对所有需要访问集群的客户端以及所有其他集群节点（使用客户端端口进行密钥迁移）开放。
2. 集群总线端口必须可以从所有其他集群节点访问。

Currently, Redis Cluster does not support NATted environments and in general environments where IP addresses or TCP ports are remapped.

Docker uses a technique called *port mapping*: programs running inside Docker containers may be exposed with a different port compared to the one the program believes to be using. This is useful for running multiple containers using the same ports, at the same time, in the same server.



按预期工作的**最小集群**必须至少包含三个主节点。对于部署，我们强烈建议使用六节点集群，三主三副本。

您将从日志中看到每个节点都为自己分配了一个新 ID：

```
[82462] 26 Nov 11:56:55.329 * No cluster configuration found, I'm 97a3a64667477371c4479320d683e4c8db5858b1
```

此特定实例将永远使用此 ID，以便实例在集群上下文中具有唯一名称。每个节点都使用此 ID 记住其他所有节点，而不是通过 IP 或端口。IP 地址和端口可能会改变，但唯一的节点标识符在节点的整个生命周期内都不会改变。我们将此标识符简称为**Node ID**。

+ redis-trib.rb必须使用ip进行初始化redis集群，使用域名会报如下错误：*******/redis/client.rb:126:in `call’: ERR Invalid node address specified: redis-cluster-0.redis-headless.sts-app.svc.cluster.local:6379 (Redis::CommandError)

+ kubectl exec -it redis-cluster-0 -n wiseco -- redis-trib.rb create --replicas 1 $(kubectl get pods -l app=redis-cluster -n wiseco -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')

  + 使用了status。podIP的bash式方式获取IP。

  ![image-20220405155756048](../../../../../../../AppData/Roaming/Typora/typora-user-images/image-20220405155756048.png)

网址 https://www.gotkx.com/?p=76



#### 关键需求：

- 集群内外均可访问
  我查找了很多资料，CSDN，思否，51CTO，stackoverflow、后来直接找 K8s 开发者的博客（提供了思路）。没有找到实测可以集群外访问的
- 支持 node.conf 文件的内容重建
  node.conf 文件，是 Redis Cluster 集群搭建后，自动生成的配置文件，如果机器非抗力的断电重启，虽然由 StateFulSet 进行维护状态，但可能节点ID、IP 发生了变化，从而丢失部分 Slot。 因此需要重建



### Redis Cluster 部分

Gossip 协议里面，ping-pong 这种机制，直接绑定了 pod 的IP，所以也反推出了，K8s 应该采用的网络模式。是 Ingress-Nginx 还是 普通的 Service，是绑定Pod IP, 还是域名。这里我直接暴露 K8s 的 Node 机器节点 IP + redis 服务端口号，

#### Gossip协议

https://cloud.tencent.com/developer/article/1662426

#### redis 启动方式

手动脚本更新redis的配置文件和启动项

```java
command: ["/conf/update-node.sh", "redis-server", "/conf/redis.conf"]
```

```java
 update-node.sh: |
    #!/bin/sh
    REDIS_NODES="/data/nodes.conf"
    sed -i -e "/myself/ s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${POD_IP}/" ${REDIS_NODES}
    exec "$@"
  redis.conf: |+
    cluster-enabled yes
    cluster-require-full-coverage no
    cluster-node-timeout 15000
    cluster-config-file /data/nodes.conf
    cluster-migration-barrier 1
    appendonly yes
    protected-mode no
```

之前笔记 [使用docker 建立Redis Cluster](https://blog.yowko.com/docker-redis-cluster)成功建立了redis cluster，也测试过sentinel 可以正常failover，兴高采烈测试程式码时才发现有bug：在加入cluster 时使用的是container ip 与port (因为redis cluster 不支援使用host name)，以致redis key 在不同slot 间无法正确做移动，所以我们马上来看看可以如何解决吧

- 这边使用固定ip，因为redis 使用container name 建立cluster 时会出现无法解析的错误，固定ip 的绑定则会透过docker-compose 处理
- 透过redis-cli 建立cluster 是redis 5 加入的功能，已经无法使用redis-trib.rb

+  简单的说，Headless Service就是没有指定Cluster IP的Service，相应的，在k8s的dns映射里，Headless Service的解析结果不是一个Cluster IP，而是它所关联的所有Pod的IP列表。

提供K8s的工具

https://10691.cn/813.html 创建pods后需要初始化集群

这里有scale 命令,只是standalone适用，

https://github.com/bitnami/bitnami-docker-redis#readme

```
 docker-compose up --detach --scale redis-master=1 --scale redis-secondary=3
```

sentinel 默认是没有用户名的，只有密码。redis 默认也不用填用户名，直接填密码（Redis database desktop)

进入desktop后，会有连接节点，需要输用户名密码

![image-20220405181812962](../../../../../../../AppData/Roaming/Typora/typora-user-images/image-20220405181812962.png)

1. **Sentinel、Docker 或其他形式的网络地址转换或端口映射应小心混合**：Docker 执行端口重新映射，破坏其他 Sentinel 进程的 Sentinel 自动发现和主服务器的副本列表。查看本文档后面[关于*Sentinel 和 Docker的部分以获取更多信息。*](https://redis.io/docs/manual/sentinel/#sentinel-docker-nat-and-possible-issues)

### Sentinel、Docker、NAT 和可能的问题

Docker 使用一种称为端口映射的技术：在 Docker 容器中运行的程序可能会使用与程序认为正在使用的端口不同的端口公开。这对于在同一服务器上同时使用相同端口运行多个容器很有用。

Docker 不是唯一发生这种情况的软件系统，还有其他网络地址转换设置可以重新映射端口，有时不是端口而是 IP 地址。

重新映射端口和地址会以两种方式与 Sentinel 产生问题：

1. Sentinel 对其他 Sentinel 的自动发现不再起作用，因为它基于*hello*消息，其中每个 Sentinel 宣布他们正在侦听连接的端口和 IP 地址。但是，Sentinel 无法了解地址或端口是否被重新映射，因此它会宣布其他 Sentinel 连接的信息不正确。
2. Redis master的输出中以类似的方式列出副本[`INFO`](https://redis.io/commands/info)：该地址是由 master 检查 TCP 连接的远程对等方检测到的，而端口是由副本自己在握手期间通告的，但是端口可能是错误的出于与第 1 点相同的原因。

由于 Sentinel 使用 master[`INFO`](https://redis.io/commands/info)输出信息自动检测副本，因此检测到的副本将无法访问，并且 Sentinel 永远无法对 master 进行故障转移，因为从系统的角度来看没有好的副本，所以目前没有办法使用 Sentinel 监控一组使用 Docker 部署的主实例和副本实例，**除非您指示 Docker 映射端口 1:1**。

对于第一个问题，如果您想使用 Docker 和转发端口（或任何其他重新映射端口的 NAT 设置）运行一组 Sentinel 实例，您可以使用以下两个 Sentinel 配置指令来强制 Sentinel 宣布一个特定的 IP 和端口集：

```
sentinel announce-ip <ip>
sentinel announce-port <port>
```

请注意，Docker 能够在*主机网络模式下运行*（查看`--net=host`选项以获取更多信息）。这应该不会产生任何问题，因为在此设置中未重新映射端口。

### https://redis.io/docs/manual/sentinel/

检查集群状态

redis-cli -a 1234 --cluster check 192.168.10.11:6375

#### https://github.com/bitnami/bitnami-docker-redis-cluster/issues/3#issuecomment-870973596

写好的redis 镜像 cluster版本，可以变更数量，但是失败了，因为那是一个私有网络。！！！

:%s/192.168.68.92/34.97.204.171/g

https://github.com/bitnami/bitnami-docker-redis-cluster/issues/3#issuecomment-917537076

docker network create --driver bridge --subnet 172.22.0.0/16  --gateway 172.22.0.1 mysql_spring

这里网络名称写错了，dockerfile文件需要修改。


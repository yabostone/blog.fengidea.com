---
title: "HDChina备忘"
date: 2022-07-11T18:53:57+08:00
draft: false
---

## 客户端

![image-20220711185413976](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1657536856/2022/07/538c815f946c968773a39535f378fb5b.webp)

## 如果笔记本不用，那就很麻烦了

## PT的优化

需要修改cache和过期时间，不然没法跑满千兆。

# PT的优化资料

https://github.com/yabostone/PrivateTrackerWiki/tree/master/seedbox-wiki-1

```Bash
vm.swappiness = 1
fs.file-max = 2000000
kernel.pid_max = 4194303
kernel.sched_migration_cost_ns = 5000000
kernel.sched_autogroup_enabled = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_tw_reuse = 1
vm.dirty_background_ratio = 20
vm.dirty_ratio = 30
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_workaround_signed_windows = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_orphan_retries = 2
net.ipv4.tcp_retries2 = 8
net.ipv4.ip_local_port_range = 1024 65535
net.core.netdev_max_backlog = 3240000
net.core.somaxconn = 50000
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_max_syn_backlog = 3240000
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.ip_no_pmtu_disc = 0
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.optmem_max = 16777216
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_adv_win_scale = 2
```

### 跑满千兆

![image-20220714193333816](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1657798418/2022/07/e127a0b07cad0b9b70b9c01619179732.webp)

额外注意不要开合并读写，这样速度慢。缓存需要这么多，不然就将缓存过期时间减少。

CPU需要4核打底，13000的1600xCPU占用率24%，所以需要4000的CPU，对应到至少i3-6100，或者X79的基础CPU。

-----

FlexGet需要下载插件！！！



本插件会爬取details.php页面，请将参数限制到合理的范围，减轻对服务器负担
本插件已尽量减轻服务器负担，因本插件造成账号封禁等损失，请自行承担后果
**建议** 将RSS条目限制在20条以内，将Flexget运行频率设置在10分钟以上。 如果不想对人数进行过滤，不建议设置seeders和leechers参数。

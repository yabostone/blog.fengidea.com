---
title: "win负载均衡"
date: 2021-08-06T23:13:22+08:00
tags: 
  - VPS
  - rclone
  - rsync
categories:
  - VPS
  - 技术
draft: false
---

#### 网络变更后的处理方式

今日学校的网络发生了变更，晚上的不限速没有了，这里意味着rclone开始不太好用，因为限速了很容易跑满，同时网络会有不稳定，需要考虑带有断点续传且不消耗vps的cpu的同步方式。

更新：

发现周末可能不会进行限速，还是可以用之前的方式了。

##### 同步方式

+ rsync
  - 支持断点续传，但是单文件，可能需要在本地端考虑多文件方式。
  - 单线程好像也是可以跑满的，毕竟只有500k。
  - 分成两个文件夹分别跑也是不错的选择。
+ unison
  + 有默认是字节级别同步，速度慢，但是也有unsafe模式。
  + 不记得是否支持断点续传。
+ bbcp
  + 好久没用没有印象了。。。
  + 命令行还要重新测试。。

##### 加快速度

需要使用负载均衡和多wan口加速，这里可用hyperv虚拟路由，但是需要多个wifi接收器，以及一定的技巧来搭建，初步考虑使用openwrt-life项目或者ikuai项目。

先用ikuai吧，openwrt多wan口还是比较麻烦的。需要自行定制内容，也不需要特殊的插件。

hyperv无线网卡只能桥接一个，没法桥接多个，使用nat代替一个。

ikuai添加64位的内存容量校验，只能选择32位的了。

**HyperV**似乎这类网络支持并不好，没法双网卡叠加。似乎不需要使用hyperv，直接通过跳跃点的方式平分带宽，考虑将hyperv网络中的东西撤掉。明天再做。

##### 使用windows10负载均衡

两种方式，一种是手动调整跃点数于相同使自动负载均衡，不过需要链接速度一致。

第二种属于推荐方式，NetSwitchTeam

[负载均衡的参考链接](https://www.wyr.me/post/659)



[NetSwitchTeam](https://docs.microsoft.com/en-us/powershell/module/netswitchteam/?view=win10-ps)是实现win10链路聚合的推荐方案。同样的，该方案不会叠加内网点对点传输的速率。

通过`Windows PowerShell(管理员)`，执行`Get-NetAdapter`查看当前网卡列表详情。

![NetAdapter.png](https://cdn.wyr.me/post-files/2021-02-05/1612521771093NetAdapter.png)

创建一个`NetSwitchTeam`：

```bash
PS C:\>New-NetSwitchTeam -Name "SwitchTeam01" -TeamMembers "Ethernet 2","Ethernet 3"
```

`Ethernet 2`和`Ethernet 3`就是`Get-NetAdapter`得到的`Name`值，可以是中文，例如`以太网 4`。

![image.png](https://cdn.wyr.me/post-files/2021-02-05/1612522110077image.png)

此时访问`网络连接`状态，可以看到`SwitchTeam01`的速度是`2.0Gbps`。

![SwitchTeam01.png](https://cdn.wyr.me/post-files/2021-02-05/1612522185015SwitchTeam01.png)

此时通过外网测速能够看到明显的叠加效果。




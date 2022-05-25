---
title: "Saltstack配置"
date: 2022-05-08T11:29:10+08:00
draft: false

---

### master

直接启动就可以

### minion 

启动前，修改minion文件下的master地址，

然后到master下面用 

```Bash
salt-key -L  列出所有key
salt-key -A -y  允许所有key
salt-key -a  192.168.0.100 -y  接受这个ip的minion

```

#### 匹配

配置os是centos的主机

-G参数对Grains数据进行匹配，L是对列表的匹配
如：匹配系统是centos的主机，而其他们版本的服务器不进行匹配

```javascript
salt -G 'os:CentOS' test.ping 
```

The `L` within group1 is matching a list of minions, while the `G` in group2 is matching specific grains. See the [*compound*](https://docs.saltstack.cn/topics/targeting/compound.html)

```YAML
nodegroups:
  group1: 'L@foo.domain.com,bar.domain.com,baz.domain.com or bl*.domain.com'
  group2: 'G@os:Debian and foo.domain.com'
  group3: 'G@os:Debian and N@group1'
  group4:
    - 'G@foo:bar'
    - 'or'
    - 'G@foo:baz'
```



### 特点 

可以是server端，然后直接连。（通过脚本生成vps，然后配置好ssh，连接后安装minion？或者直接在cloud-init下或者开机脚本安装minion。sed 配置master。

如果是ansible的话，配置好ssh，配置本地hosts，配置group，连接ssh直接操作yaml。

（如果是云的话，好像ansible方便点。）（如果是本地proxmox的话，配好基础镜像后设定模板。然后模板生成vps）如果是云，不想用存储镜像，那就设置开机命令，添加ssh-key和sed sshd。python3



各自操作云厂商其实最好用每个云的命令行，加快速度，terraform并没有提供统一的抽象，



感觉还是用saltstack 更加方便，跳出了ssh的。可以部署在云上。

--------------------------------

部署内容 ，部署一个saltstack节点到oracle，

部署一个pushdeer到oracle。

oracle 部署无状态的服务，可以快速迁移，只要改dns的服务。

部署支持变更参数的ddns-go 服务。oracle 的主机名和dns 对应

ddns 的webhook 接入pushdeer可以。



部署quickbox 到主机，但是这个不知道放在哪，感觉放自己在哪就放在自己在的地方比较合适，这里只是暂时在的时候放着，不在不放。

部署web服务，这里大多数的node的vue项目可以用serverless。

部署需要长期保持的软件。如定时ping任务。判断服务是否在线。

定时检测任务。

还有日志状态保存等，但是这个用netdata+数据库

部署一个宝塔。（这里可以放oracle）。。。

演示站

！！！ 可以部署nps！！！（出现ip变化后就用脚本自动重启服务 更改ip后（没必要，设定好op端口就好了）

！！！ 监控脚本，，咦我之前配置的xxl呢？？说明不是常见常使用的就会出问题。配好了没去用。。。

还有jetbrains 配置的java springcloud，因为放在2640的主机环境，被我删掉了。。

后端提供服务的可以放在自己ipv6的机子上。

！！！ mysql，mongodb 等一系列的数据库服务可以放在本地，

！！！ 快速生成虚拟机或者lxc。

消息推送可用



#### 如果saltstack master ip变化

那么我们就无法连接了。考虑内部的master，再考虑外部master。

#### 脚本配置安装salt

Ubuntu下面

https://techviewleo.com/install-saltstack-master-minion-on-ubuntu/

### 用脚本配置安装saltstack

一直报错。。saltstack的github说是版本问题，salt-master需要更新到最新。。。

alpine更新吧。。。

https://repo.saltproject.io/#ubuntu

![image-20220521162849200](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653121731/2022/05/624202e6fd17fc74d633239ca20bd0a6.webp)

选择稳定版不是最新版！！！！

### 配置edge

```
#http://mirrors.nju.edu.cn/alpine/edge/main
#http://mirrors.nju.edu.cn/alpine/edge/community
#http://mirrors.nju.edu.cn/alpine/edge/testing
```

没有用，版本不对应，ubuntu的版本最新，alpine的edge下还是rc.0,默认版本没有更上。

ubuntu的版本还不能调整，只能用ubuntu作为master。

###### 配置minion

sed -i "s/archive.ubuntu.com/mirrors.nju.edu.cn/g" /etc/apt/sources.list



sed -i "s/security.ubuntu.com/mirrors.nju.edu.cn/g" /etc/apt/sources.list

设置ubuntu的命令

sed -i "s/ftp.debian.org/mirrors.nju.edu.cn/g" /etc/apt/sources.list

sed -i "s/security.debian.org/mirrors.nju.edu.cn\/debian-security/g" /etc/apt/sources.list

设置debian

调试bug

 salt-minion  --log-level=debug

**debian和ubuntu互通，那么，设置alpine的master需要是单独的才能设置，不然就单独设置ssh通道。设置镜像包。**

还是3004.1，稳定版也是这个，无奈了。



### 设置ip变更

1.获取主机名称  salt "*" grains.items 

！！！！ **grains是静态的，包括ip地址，只会在启动时收集。**

```bash
 master:
        192.168.0.11
 os:
        Alpine
 os_family:
        Alpine
 osarch:
        x86_64
 ipv6:
        - ::1
        - 240e:3a1:6266:67f0:a0f6:b6ff:fec0:7a15
        - fe80::a0f6:b6ff:fec0:7a15
     fqdn:
        salt-alpine.zte
    fqdn_ip4:
        - 192.168.0.11
    fqdn_ip6:
    host:
        salt-alpine   ### host 就是可以用来作为域名前缀的，salt-alpine.internal.dlink.bid salt-alpine.v6.dlink.bid
```



2.触发机制

如果ipv6的主机名称发生变化，那么就触发更新自动重启，

或者通过ddns的机制，ipv6发生变化，那就调用hook，hook调用salt完成内容。

这个没法用grains做，grains静态的。

需要启动pillar ，在master 的配置项内添加内容。

可用脚本python定期获取ipv6数据，然后更新到grains中，salt-master定期查询grains，进行更新

可以定期调用network模块判断内容。



![image-20220521174949516](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653126592/2022/05/e8b8d33a0a403143ae5d80b45054921b.webp)

`salt.modules.network.``ip_addrs6`(*interface=None*, *include_loopback=False*, *cidr=None*)

Returns a list of IPv6 addresses assigned to the host. ::1 is ignored, unless 'include_loopback=True' is indicated. If 'interface' is provided, then only IP addresses from that interface will be returned. Providing a CIDR via 'cidr="2000::/3"' will return only the addresses which are within that subnet.

*Changed in version 3001:* `interface` can now be a single interface name or a list of interfaces. Globbing is also supported.

CLI Example:

```
salt '*' network.ip_addrs6
```

###### git后端

git后端可以不用，直接用rootfs。

##### 触发机制

这里触发机制应该是用cron或者什么直接判断后调用saltstack进行处理。

高级点就是用nomad这类或者xxl-job进行调用触发。

###### 配置pip

```Bash
pip config set global.index-url https://mirror.nju.edu.cn/pypi/web/simple

```





#### pillar设置

pillar只能master 端设置 。client端执行。

而pillar信息只能在master端配置，在到minion端执行

##### 全球的ipv4地址由dns获取

**指定nameserver！！！！**

![image-20220522090534970](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653181538/2022/05/8d3caf68208d69632e67950333bc3f90.webp)

### alpine安装psutil

apk add py3-psutil

不用安装build-essential



https://blog.csdn.net/qq_30068487/article/details/90297814

https://jaminzhang.github.io/saltstack/SaltStack-Using-Jinja2/ 模板 和获取值。



这种特殊的配置，估计只能用cmd.run 配置下去。

没有监控？？ 没有监控文件改变的，需要定期用salt？

本地放在自动更新内容。

server端单独设计python脚本。变更ip，就在脚本内完全变更ip的值，完全重启。

client端的内容变更，一种思路是update的https的脚本内容，定时获取值。ansible和salt都可以设置source为HTTPS的file。

另外一种是通知，client端检查dns是否变化，如果发生变化，说明ip变化，说明需要变更内容。

这里的python作为服务要用nomad，方便查看，如果手动的话会忘记。一个域里面只要一个nomad就可以了。

（域名里面包括dns的费用了。）


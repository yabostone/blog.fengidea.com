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


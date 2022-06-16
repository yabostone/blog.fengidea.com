---
title: "Saltstack在Ubuntu22.04下单机测试部署"
date: 2022-06-13T18:25:10+08:00
draft: false
---

==在Ubuntu22.04下面，单机部署master和minion出现权限问题，不生成对应的pki。

master在pki下的权限是salt:salt,minion在pki权限root。

需要在master和minion下的配置文件中使用pki_dir,默认的既可以，然后到pki文件夹下看对应的权限。

![image-20220613182738336](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655116060/2022/06/6b447d8da2c6d8377f7697f3247c1aef.webp)

可以看到两者权限不同。

![image-20220613191344527](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655118826/2022/06/4ece2358b42352df43ad778e13fe9aff.webp)

总是无法访问，但是srv的文件夹可以为True，推断是权限问题，到service里面将user和group改成root吧。

修改root方式失败，还是salt作为用户，查看了debian11，是由debian11引入的，ubiuntu20.04没有变化。

解决方案：

将vscode的默认文件夹转为/srv/  以后也可以这样做。

### 配置

```Bash
 salt "*" state.sls saltenv=dev ddns-go.pre test=True
```

版本变更为saltenv，不是env了，然后ddns-go为services对应的文件夹，

```Bash
ddns-go-pre:
    file.managed:
      - name: /tmp/ddns-go.templ
      - source: salt://ddns-go/ddns-go-config.templ
      - user: root
      - group: root
      - mode: 0755

ddns-go-source:
    file.managed:
      - name: /tmp/ddns-go.tar.gz
      - source: salt://ddns-go/ddns-go_3.7.1_Linux_x86_64.tar.gz
      - user: root
      - group: root
      - mode: 0755
    cmd.run:
      - name: cd /tmp/ && tar -zxvf /tmp/ddns-go.tar.gz && ls /tmp/ddns-go
      - unless: test -d /etc/ddddd
      - require:
        - file: ddns-go-pre
        - file: ddns-go-source

```

+ salt目录为直接搜索到的salt的dev下面的services文件夹，然后直接ddns-go。便于复制粘贴。
+ 默认目录在用户home下，root为/root,所以tar之前需要cd 到对应文件夹下面，再复制。

##### 使用grains和jinja2

```Bash
      - template: jinja    # 1. 增加这行表示开启模板
      - defaults:          # 2. 下面设定变量的值
        ipv4hostname:   {{grains["host"]}}
        ipv6hostname:   {{grains["host"]}}
```

```Bash
  domains:
  - {{ipv4hostname}}.internal.dlink.bid
```

###### grains信息出现变更

如果自动更新了ipv6，那么发起一个restart所有的salt-minion的信息就好啦。。自己写内容注入到配置管理服务也可以，添加到注册发现也可以。强制刷新grains也可以

刷新grains方法：
　　（1）重启minion
　　（2）Master强制刷新： **salt '\*' saltutil.sync_grains**

---
title: "Ansible Playbook配置openwrt"
date: 2022-06-14T00:47:15+08:00
draft: false
---

== ansible 配置openwrt。

使用rsync 时候，需要先用命令测试成功后才能用playbook，不然不成功。

```Bash
ansible test -m synchronize -a "src=./ddns-go.init dest=/mnt/sda1/test/ recursive=yes"
```

```Bash
- hosts: test
  tasks:
    - name: rsync test
      synchronize:
        src: ./ddns-go.init
        dest: /mnt/sda1/test/ddns-go.init
        recursive: yes
```

copy 模式支持目录，但是目录如果没有则需要先创建。

#### 思路

可以将op上的配置文件上传oss中，然后在ansible中先用shell拉数据，再用ansible分发到新的op中。

op的配置文件上传使用shell脚本，rclone已经配置好了，定时推送即可。二进制的也可以推送。

![image-20220614110134592](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655175696/2022/06/bbea3d518c114aa499a805e80d99db27.webp)

注意防火墙。

##### 手动 部分

指定域名分流

![image-20220614211823557](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655212705/2022/06/714ff60a3cc7306d2a244959034806bc.webp)

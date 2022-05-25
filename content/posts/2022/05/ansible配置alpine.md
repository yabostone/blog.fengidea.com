---
title: "Ansible配置alpine"
date: 2022-05-08T08:55:36+08:00
draft: false

---

设置alpine的ansible方法



```Bash
- name: docker-alpine
  hosts: test
  become: true
  become_user: root
  tasks:
    - name: Install docker
      apk: name=docker update_cache=yes

    - name: Start docker daemon at boot
      shell: rc-update add docker boot

    - name: Start the docker service
      service: name=docker state=started
```



### vim 自动缩进的方式

![image-20220508085927009](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651971671/2022/05/97af2b69b97d8a04b29ba0d717b89556.png)

```Bash
- name: docker-alpine
  hosts: test
  become: true
  become_user: root
  tasks:
    - name: Install docker
      apk: name=docker update_cache=yes

    - name: Start docker daemon at boot
      shell: rc-update add docker boot

    - name: Start the docker service
      service: name=docker state=started

    - name: add docker daemon file
      copy:
        src: /etc/docker/daemon.json
        dest: /etc/docker/daemon.json
  
    - name: docker restart
      service: name=docker state=restarted
```

yaml 需要用vscode编写，不然用命令行，太麻烦了，还要配置编辑器。

json 文件如果没有特殊需求，就用复制的方式，不然就是用var的方式写，inline的方式不适合这个。

```Bash
rc-update add docker
```



## 配置gcloud

```Bash
curl -sSL get.docker.com | sh
source <(curl -sL https://multi.netlify.app/v2ray.sh) --zh

gcloud compute instances create instance-1 --project=enduring-rush-344710 --zone=asia-northeast3-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script=curl\ -sSL\ get.docker.com\ \|\ sh$'\n'source\ \<\(curl\ -sL\ https://multi.netlify.app/v2ray.sh\)\ --zh$'\n',ssh-keys=OpenSSH-rsa-import-020919:ssh-rsa\ AAAAB3NzaC1yc2EAAAABIwAAAQEAyy21qYJ/2lH2JgkmdfdHVB\+DJ8wAFIGLR62NNoy6yVw7qJ3y2S\+DkR/ke8JinE09Cr1E96Jb9SNdKuAeEK8TwueNbxEKFKrscfWobwK9tZCAb2jXJb/OpbQJCmOlUqxPK4JXgfR4Rs2PSbpcpOHbkLTC2UKzELjkMXbbkvjE/Rv/k1Uy8qibZQjQrSugShebrrOPkGVRyMYMzpCrbI\+wrU4YrnOl9uWCTgGHuJ5Np57DUZypkWTPdQhzR5lJyCwL50f70JkWJEYFhXADsqyB\+35KAyuXlvd/BitSrJMKN26UY4J/7lo8R4nywsNGGXKrcvd2C5SHCK5kkDlQ1G6BPw==\ OpenSSH-rsa-import-020919 --no-restart-on-failure --maintenance-policy=TERMINATE --provisioning-model=SPOT --instance-termination-action=STOP --service-account=324635486142-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server,all-port,all-ports --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220406,mode=rw,size=10,type=projects/enduring-rush-344710/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

```

### 配置防火墙

+ 入站和出站都要设置，不适用默认的。
+ 名称要记住，在network的应用类型中添加。
+ ![image-20220508193637059](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652009799/2022/05/79bdb54f3ae8f7381c6ae9d0374afd4f.png)

网络标记为 入站和出站都配上的内容。



### 配置wall

仅记录，自用

https://github.com/HyNetwork/hysteria/wiki/%E5%85%B3%E4%BA%8E-Docker

###### hysteria

导入pw时混淆密码应该设置为空.

###### v2ray协议

https://github.com/Jrohy/multi-v2ray/blob/master/v2ray  见这个文件，

可以 `v2ray add utp` 创建端口

### 限制协议

!!!限制UDP的服务商排雷列表【2022/03/21更新】

digitalocean : 有时可用，有时不可用，防火墙规则深不可测，它的floating ip有着更为严格的规则。
vultr：和DigitalOcean表现一致
virmach：曾同地区电信可用，移动不可用。
aws: 当你使用ec2实例使用udp/wechat-video模式等udp模式时，会被aws认为是对外的udp攻击，收到警告邮件。
ovh: 可用udp模式，但是会时不时的断流一下，faketcp没问题

### ssh相关

1.手动修改sshd_config文件，好像和其他的不一样，这样配置

2. 手动将user的.ssh 文件夹放在/root/文件夹下
3. 这里操作这么麻烦不如用salt。。。

```Bash

```



### pve 被lock

进入pve shell命令行中， 如果需要杀的vm是101， 那就先删除，101的lock文件，之后unlock 101

```
ls -l /run/lock/qemu-server
rm -f /run/lock/qemu-server/lock-101.conf
qm unlock 101
qm stop 101
qm status 101
```



### 添加一个路由作为新的路由补充

这里E1620的静态地址和dhcp分配的，这块很差，然后估计端口转发的数量也是受限的。加上ipv6的没法获取pd。只分配/64。同时没有静态路由

所以，解决方法1. DHCP的可能再设立一个，但是之前固定的那些端口需要完全添加，而且会注意到软路由失效的问题。（DHCP分配ip，netmask，dns，这几个）

1.1 如果再创建dhcp，ip和netmask设定相同，dns添加192.168.0.1 和192.168.0.2，这里dns设定好。这个部分设定给什么在用？？还是给虚拟机啊。。



1.2 如果不创建dhcp，上三项全部手动设定。

2.dhcpv6的设定。默认可以直接去掉内网ipv4地址，再进行分配。创建路由分配内网。这里可以选择添加



既然作为虚拟机，那就准备一个内网的虚拟机，ipv4，用dmz ，或者端口范围全暴露。ipv6全部relay。

同时这里默认分配dns为op的，带本地域名？？ 其实可以加ddns作为全球域名的。



另外一台6110的机子就全部0.x内网。如果要透明代理，那就开两个LAN口，一个lan口不开v6？

可设定v6的dns，？？ 再看。

3.用quickbox-lite的可以用deluge下。

4.设置两个op，一个专门透明代理（只开v4）。一个专门端口转发和分发

#### k3c的允许ipv6

https://www.right.com.cn/forum/thread-460235-1-1.html

然后relay的方式（没有pd）

https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=333404&highlight=%B9%D9%B8%C4%2Bv6




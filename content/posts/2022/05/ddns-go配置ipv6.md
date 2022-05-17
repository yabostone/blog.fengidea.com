---
title: "Ddns Go配置ipv6"
date: 2022-05-03T13:13:01+08:00
draft: false
---

添加服务将配置ipv6的ddns

### 本想着自己写

发现有ddns-go项目，已经2-3年了，用了下还是不错的。

只要将每个需要暴露端口的都运行就可以了。

时间间隔也可以设定

> https://github.com/jeessy2/ddns-go

可选] 支持启动带参数 `-l`监听地址 `-f`同步间隔时间(秒) `-c`自定义配置文件路径。如：`./ddns-go -l 127.0.0.1:9876 -f 60 -c /Users/name/ddns-go.yaml`

#### 端口转发

v6可以用宝塔面板的nginx作为端口转发，不然的话看看openwrt上面有没有端口的转发,有socat的运行界面，也可以用iptables转发。socat性能强大了。



![image-20220503131738218](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651555068/2022/05/033b200a7e852198237a4735741abfa7.webp)

#### 关于nps的socks代理和http代理

这个代理默认有客户端的基本用户和密码，但是权限还是太大了，不敢用。

测试只能用firefox或者其他的代理软件登录。chrome下面的不能访问。可以访问192.168.18.1和192.168.10.1和192.168.0.1，这个权限太大了。还是用私密代理访问比较合算。

p2p代理不适用，这里的nat层数过多，除非用端口转发的方式暴露端口。



#### 关于todesk和向日葵

这个可以设置成默认，有重试次数，然后将密码设置的复杂些就好，缺点是要用windows。。以及最好放开端口。

然后windows的远程连接可以是ipv6，所以远程连接密码设置复杂些。

也可以是向日葵或者todesk或者anydesk，密码设置复杂些。

#### 如果rdp，todesk等均不能访问

那么考虑配置好的nps进入内网访问。



#### 自动开机部分

这里需要有一台能够发送wakeonlan的机子。这里可以是路由器的ssh，支持192.168.10.0网段和192.168.0.0网段

然后路由器的ssh端口暴露

，wakeonlan用的是 **etherwake**

ssh需要转为秘钥方式

也可以用npc的开机启动到路由器啊。。。

##### 路由器newifi3

启动opkg了，然后添加了etherwake。

并且ssh默认为newauth

![image-20220503180556276](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651572366/2022/05/e08a64ebd467d7a2405dd9b3f3aae09d.webp)

非常扯淡的是，这个老毛子默认装了nps的管理界面，还可以自动下载npc和nps。。。

参见

![img](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651573238/2022/05/88b24a03bbd0d255f2b1f2a891f95f36.webp)

### alpine 换源

```Bash
sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
sed -i 's/dl-cdn.alpinelinux.org/mirrors.nju.edu.cn/g' /etc/apk/repositories

   rc-update add docker
   rc-service  docker start
   
   rc-service crond start
rc-service ddns-go start
```



> 

### 配置内容

```Bash
sudo mkdir /etc/ddns-go/
./ddns-go -s install -l 0.0.0.0:9876 -f 60 -c /etc/ddns-go/config.yaml 

docker run -d --name ddns-go --restart=always --net=host -v /opt/ddns-go:/root jeessy/ddns-go -l 0.0.0.0:9876 -f 60 

```

#### yaml格式

YAML也有用来描述好几行相同结构的数据的缩写语法，数组用'[]'包括起来，hash用'{}'来包括。因此，上面的这个YAML能够缩写成这样:

```
house:`` ``family: { name: Doe, parents: [John, Jane], children: [Paul, Mark, Simone] }`` ``address: { number: ``34``, street: Main Street, city: Nowheretown, zipcode: ``12345` `}
```

- “-” 标识清单，对标[] , 列表形式	

##### 配置openssh

```Bash
 apk add openssh-server 
 apk add openssh-client
```

## 配置ipv6

这里的路由器居然有静态地址数量限制，那应该也有端口转发数量限制，所以，思路转为建立一个旁路由，然后dmz对应端口，端口转发用这个旁路由的方式端口转发。

或者将http和https的端口用宝塔设定成同一个，但是数量还是受限。

![image-20220509103329481](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652063614/2022/05/4f0a38108208876131c3b10852f78e5a.png)

```Bash
config dhcp 'lan'
    option interface 'lan'
    option start '100'
    option limit '150'
    option leasetime '12h'
    option ra 'relay'
    option ndp 'relay'
    option dhcpv6 'relay'
    option ra_management '1'

config dhcp 'wan'
    option interface 'wan'
    option ignore '1'

config dhcp 'wan6'
    option interface 'wan'
    option ra 'relay'
    option ndp 'relay'
    option dhcpv6 'relay'
    option master '1'
```

**二级路由三个relay加一个master。**

https://cangshui.net/4730.html

设置 ipv6的 带d开头的内网ipv6的openwrt。就会是内网ipv6



**如果ULA不进行设置，在上面的基础上那就默认全部获取上级的ipv6的值。**



### autoremovetorrents

这个位置在

> /home/mxuan/.config/autoremovetorrents/config.yaml
>
> 

### 可配置aria2的远程下载。。

1. 支持webdav文件协议，可以将阿里云盘当做webdav文件网盘挂载到Windows, macOS, linux的磁盘中进行使用。webdav部署支持docker镜像，镜像只有不到10MB非常小巧。



### 配置quickbox时候

实际上cloud-img的img文件实际上是qcow2格式的，所以还是要转换到raw格式

```Bash
qemu-img convert -f qcow2 -O raw focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64.raw

```

### 先禁止ipv6

sysctl -p的

#### 强制分发桌面 。没办法的样子。

#### 然后配置dns到默认dns

需要更新resolve

https://www.myfreax.com/set-custom-dns-servers-on-ubuntu-18-or-20/

**其实可以用cloud-init的dns更新的。。。。**

### 强制千兆，pve默认到百兆了。

apt install ethtool -y

> ethtool –s enp2s0 speed 1000 duplex full autoneg off

有时候会报错，那就先减少命令选项，判断能用后再开

```Bash

ethtool -s enp2s0 speed 1000 duplex full autoneg off

ethtool -r enp2s0

ethtool enp2s0

```

###### 测速

```
fio -filename=/var/test.file -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_r_w -ioscheduler=noop
```

### 硬盘性能。。。

用ext4的硬盘性能随机写65MB，而lvm-thin的随机写只有25MB/s....

用fio测试性能速度

```Bash
fio -filename=/var/test.file -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_w

fio -filename=test.file -direct=1 -iodepth 1 -thread -rw=write -ioengine=psync -bs=16k -size=2G -numjobs=10 -runtime=60 -group_reporting -name=test_w

在小文件速度上，lvm和zfs等性能比裸机ext4好。


```







## ssh的sed

正则表达式和 sed 可以帮助处理这样的事情。

```
sed -re 's/^(PasswordAuthentication)([[:space:]]+)no/\1\2yes/' -i.`date -I` /etc/ssh/sshd_config
```

在我的 Debian 系统`PasswordAuthentication no`上`PasswordAuthentication yes`，无论键和值之间有多少空格，这都会切换到。

它将在创建原始文件的备份时替换文件中的选项（就地编辑），后缀由日期 ( `sshd_config.2014-05-28`)命名。

切换位置为是和否以切换其他方式。

删除前导的表达式`#`是这样的：

```
 sed -re 's/^(\#)(PasswordAuthentication)([[:space:]]+)(.*)/\2\3\4/' 
```

\- 并插入前导 -`#`符号：

```
 sed -re 's/^(PasswordAuthentication)([[:space:]]+)(.*)/#\1\2\3/' 
```

要`#`在前面使用可选的-sign切换一行（感谢 Barlop）：

```
sed -re 's/^(\#?)(PasswordAuthentication)([[:space:]]+)no/\2\3yes/' 
```

在所有这些表达式中，您可以更改`PasswordAuthentication`为您想要更改的任何其他选项 - 甚至可能将其设为 shell 脚本中的一个键，并制作一个“sshd 选项切换工具”。

Sed 和 regex 都很有趣和游戏，但我确信 Valentin 是正确的，如果你有很多系统，配置管理是要走的路。就我个人而言，我只是在几个很少更改的系统上使用 etckeeper/bazaar - 这不是配置管理，但它为我提供了版本控制，因此在我搞砸了正则表达式和`sed -i`. :)



### 网络控制

要安装ifupdown 才能  /etc/init.d/networking restart

.....

现在的问题是，没有 DDNS 非常非常不便，联通的检测原理是反查？之前为了测试服务，该主域名曾在被使用在国内网站上，当时该国内网站的系统提示域名没有备案无法访问，还差点把主站都搞崩了……也曾怀疑过是不是因为这个而把域名暴露了……

qbittorrent 跑几十 T 流量，然后抓包到访问 qbittorrent 网页管理页面，两个条件满足，就判定你在提供服务了。

所以一条宽带大流量不提供服务，另一条小流量提供服务，两个条件不同时满足，就没事了



和未备案有关？但是按照相关规定，备案了也不能解析到家宽上，这个是明确的。
和 DDNS 请求有关？运营商使用 DPI 系统，sni 是明文的情况下加不加 HTTPS 没意义啊

和你主站域名没有任何关系。之前我用来做 ddns 的域名根本没有任何网站，主域名和 www 根本没解析，只开了个 22 端口 ssh 登录都被检测了，明显是统计的 DNS 流量。

不要用家宽开 web 。你能想到的端口映射、白名单、端口敲门等手法通通没用。运营商可以通过分光镜像和 DPI 设备看到你的所有流量，过滤出 dns 流量和入站 http 流量很容易。另外 https 流量的特征也很明显。

是 https://yuming:66666 这种，挂了个传文件用的网盘啊，总要有网页的，存的都是些视频啊、盗版 AE 插件啊什么的，不过没账户进不去就是了……

**带账户也不行。。。**

北京联通。
光猫桥接，自购华硕路由拨号。
用的华硕路由自家的 DDNS 。
未开通 Web 服务，DDNS 仅用于接入 VPN，手机通过 VPN 接入家庭网络，然后再访问家庭局域网内部资源。
[域名是国内平台购买的.cn](http://xn--ckqx8ecvcjd86nyqb5yyr6ojv8anmzc.cn/) 结尾的域名，进行了实名验证，但未备案，在 DNSPod 上解析。

联通没有因为这事找过我。

仔细看一下合同，没有直接规定这个事情的话，可以以“使用 DDNS 发现家庭网络 IP 用于查看自家视频监控系统”为由，投诉到工信部试试。我记得过去 v 站有过相关案例，不是未备案的问题，是有的地区运营商会委托第三方公司做安全扫描。有的家里宽带连接两三个网络摄像机的，被扫描到了网络摄像机的登陆界面，都会被要求整改和写保证书

### 考虑自建moon节点

直接建立到公司的这个IP上，

或者用wireguard，不过这个也会被查。



我用的方案是，在 NAS 上搭一个 ss，然后配合科学上网软件，把常用的服务 dns 直接指向内网 ip，然后走代理通道，这样 80 、443 也能用，科学上网只需要配置家里的路由器就好了，也检测不到是 http 请求。

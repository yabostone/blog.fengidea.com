---
title: "Ddns Go配置ipv6-op配置ipv6-relay"
date: 2022-05-03T13:13:01+08:00
draft: false
---

添加服务将配置ipv6的ddns

> 配置ipv6下的relay。
>
> https://www.aladown.com/2021/06/%E7%AE%80%E5%8D%95%E5%B9%B2%E5%87%80%E7%9A%84Openwrt-ipv6%E9%85%8D%E7%BD%AE-%E5%B1%80%E5%9F%9F%E7%BD%91WAN6%E4%B8%AD%E7%BB%A7%E6%A8%A1%E5%BC%8F%E8%8E%B7%E5%8F%96%E5%8E%9F%E7%94%9Fipv6%E5%9C%B0%E5%9D%80-%E6%97%A0%E9%9C%80PD/

### 本想着自己写

发现有ddns-go项目，已经2-3年了，用了下还是不错的。

只要将每个需要暴露端口的都运行就可以了。

时间间隔也可以设定

> https://github.com/jeessy2/ddns-go

可选] 支持启动带参数 `-l`监听地址 `-f`同步间隔时间(秒) `-c`自定义配置文件路径。如：`./ddns-go -l 127.0.0.1:9876 -f 60 -c /Users/name/ddns-go.yaml`

> ./ddns-go -s install -f 30
>
> 设置30x5的间隔，然后选择配置生成的yaml文件



### 注意ddns 需要先放在path路径中

ddns -s install 是直接将ddns的地址写在systemd中间。



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

!!!!重启使用odhcpd！！！

```Bash
/etc/init.d/odhcpd restart
# 使用odhcpd 重启，编辑/etc/config/dhcp文件
```



！！！ 下面是 `/etc/config/dhcp` 中的配置

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

设置 ipv6的 带d开头的内网ipv6的openwrt。就会是内网ipv6。**这个内网的ULA前缀必须设置。**

接着一定要LAN口设置分配ipv6的/64。

！！！ 是配置到 /etc/config/dhcp 中！！！。不是在network中！！！







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

（18天，IP开始变更了)

我用的方案是，在 NAS 上搭一个 ss，然后配合科学上网软件，把常用的服务 dns 直接指向内网 ip，然后走代理通道，这样 80 、443 也能用，科学上网只需要配置家里的路由器就好了，也检测不到是 http 请求。



#### 使用 Moon

普通的 Zerotier 成员使用 Moon 有两种方法，第一种方法是使用 `zerotier-cli orbit` 命令直接添加 Moon 节点ID；第二种方法是在 zerotier-one 程序的根目录创建`moons.d`文件夹，将 `xxx.moon` 复制到该文件夹中，我们采用第一种方法：

https://tvtv.fun/vps/001.html

出现ip变更后，就离开moon再连上moon就可以啦。改端口也可以用orbit参数。

![image-20220519153742150](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652945865/2022/05/11a22c2d3cf9c240d1f786e09eb83651.webp)

powershell 使用

##### 使用trigger

通过ddns调用一个内网的URL，由docker 构建，rest操作本地的ansible？saltstack自动更新每个moon和客户端。需要saltstack配置管理

###### zerotier

先安装gpg，再用命令

```Bash
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
```



配置IP

sed -i "s/public/49.67.189.28:9993/g" moon-1.json

配置选择 

https://blog.angustar.com/archives/ZeroTier-Moon.html

写相关saltstack脚本按照这个来。

zerotier-cli orbit 5625b0d06b 5625b0d06b

这个命令不可用，moon的连接依赖于zerotier中心节点服务器，所以需要用网页或者rclone或者s3等配置。或者saltstack配置管理服务。不是不可用，moon的文件已经配置好了，就是配置的问题。

zerotier-idtool genmoon moon.json

更新，扫描了端口，端口转发只限定了从外扫到内，没有限定内网的port转发到外网的port ？

好像端口转发没法用，被阉割了。。。

我倒。。。默认不开启端口，直到几秒钟之后才开启端口。。。防止被探测。。

可能是路由问题，不能用另外一个路由的网关。

！！！！ primaryIP的写法出错，还是在用9993端口。



http://blog.dengxj.com/archives/9/  SoftEther

![image-20220519195841706](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652961524/2022/05/7a2c3695e1ee227afb4afd1e5b4d4b53.webp)

默认本地配置

https://docs.zerotier.com/zerotier/zerotier.conf/

9999 使用local确实改了端口，但是使用moon时候生成的端口是随机的，如上图所示所以可能需要dmz。。。

![](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652963220/2022/05/41d6796d5550109ae108392a06677814.webp)

成功了，确实**只能用DMZ才能正常作为MOON节点。而且需要deorbit和orbit**

这里还可用IPV6的方式设置MOON，可以增加连通几率。



如果不方便在op路由器上设置moon的话，考虑用ubuntu作为DMZ，设立nps和moon，以及wireguard，还有n2n（n2n的路由开始不接受）可以放frps，然后连得时候用路由连接就可以了。。。再将op作为单独的一个主机考虑。（op去掉了docker）！！！对openwrt没法搭nps服务器，没法搭frps服务器，op上的都是客户端。sooooooo。。

先学习下wireguard吧。

！！！！ 可以考虑docker 作为moon节点？？https://imgki.com/archives/234.html

# 配置MOON(进阶)

使用 zerotier-cli listpeers 命令时能看到这几个名词。充当 moon 的机子最好有公网 IP
**PLANET** ：行星服务器， Zerotier 各地的根服务器，有日本、新加坡等地
**Moon** ：卫星级服务器， 用户自建的私有根服务器，起到中转加速的作用
**LEAF** ：相当于各个枝叶， 就是每台连接到该网络的机器节点

MOON又称为自定义根服务器，通过自定义的服务器作为跳板加速内网机器之间的互相访问。

在启用ZeroTier后，我发现ZeroTier安装目录/var/lib/zerotier-one（这个目录实际链接到/var/lib/zerotier-one_sample_config）是临时目录 ，在重启后就自动删除，必须修改配置文件，才能保留MOON的配置。

## 修改配置

修改 /etc/config/zerotier，加入下面一行选项：

option config_path ‘/etc/zerotier'(注意分隔符，如下图所示)
然后在根目录的/etc/目录下，新建zerotier目录用来存放moons的配置文件。

## 生成MOON文件

进入ZeroTier的安装目录：

cd /var/lib/zerotier-one_sample_config
运行下面两条命令：

zerotier-idtool generate identity.secret identity.public
zerotier-idtool initmoon identity.public >>moon.json
在当前目录生成moon.json文件。

## 修改MOONS文件

修改 moon.json文件中”stableEndpoints” 字段为LEDE路由的公网IP，9993为端口号。

“stableEndpoints”: [ “117.XX.XX.XX/9993” ]

## 生成签名文件

运行命令：

zerotier-idtool genmoon moon.json
在当前目录下生成签名文件00000005ff20a0f6.moon

## 将MOON节点加入网络

将LEDE本机设为MOON节点。
在/etc/zerotier目录建立moons.d子目录，将生成的00000005ff20a0f6.moon复制到该文件夹中，并重启设备。

![image-20220519212452573](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652966694/2022/05/c2404cf6dc46f00214f49fc4d8859c24.webp)

图上看是固定目录，可以直接生成的。

操作方式选用ansible，调用对应api就好。



WireGuard是基于C语言编写，简单说来具备以下特性:

- 基于UDP协议
- 核心部分：加密密钥路由
  - 公钥和 IP 地址列表（AllowedIPs）关联起来
  - 每一个wg接口都有一个私钥和一个 Peer 列表
  - 每一个 Peer 都有一个公钥和 IP 地址列表
- 发送包时，AllowedIPs起到路由表的功能
  - **正常情况下，Peer的每个AllowedIPs，应该填写一条静态路由到wireguard设备!!!**
- 接收包时，AllowedIPs起到权限管理的功能：Packet的Source IP位于服务端的 AllowedIPs 列表时被接收，否则被丢弃
- https://lqingcloud.cn/post/network-01/

[WireGuard](https://zh.wikipedia.org/wiki/WireGuard) 是一种更快更简单的vpn，在熟练之后，使用 WireGuard 搭建内网，只需要几分钟
使用 WireGuard 搭建内网，需要每台机子都要配置其他的所有机器为 peer，例如 ABC 三台机器组建内网，A 需要启动一个interface，并配置B、C两台机器为 peer；B、C机器亦然。
所以，如果是少量机器的话，WireGuard是非常好的选择，但是机器多了的话，可能其他的方案更合适



PostUp 和 PostDown 就是启动后和停止后的命令，是 Linux 的话就推荐写 iptables 放行转发和做 NAT。

这个是不存在服务端，客户端的。双方的关系是对等的。如果你不填端点主机就是服务端，填了就是客户端，可以作为客户端访问对端的资源。当然如果你两边都有公网IP的话，两点都可以填端点主机，互为客户端。这里路由器作为手机的客户端，填刚才生成的客户端的公钥client0-publickey
服务端和客户端的配置配完了，下面配置一下防火墙

![企业微信20220328-111505@2x.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e541a207c48c4e159638b3fbf7a453fd~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)

在Picgo上可以看到中继服务器是可以的，**这里估计要用中继服务器，然后需要用iptables的方式转发。**



先配置  防火墙关注这个链接  https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04

**本地测试成功，注意两边均要添加iptables作为定向流量，**

在本文中

```Bash
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -o vpn0 -j MASQUERADE
```

需要在openwrt中添加对应路由的转发才能成功。防火墙将所有这个ip段的数据全部转发到vpn0上面，通过172.20.0.10/32 进行转发。

![image-20220520093351089](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653010434/2022/05/4809fe4be5e5d4d2e3cd745f49443944.webp)

这个endpoint 表示去这个peer通过哪一个接入点，这个接入点实际上在本机上的wg0的，但是连接时候走这个接入点解决两边一边在客户端的问题。

所有 vpn 协议到特征都很明显，本来就没做混淆的考虑。主流 vpn 协议忘记哪看到过是在省级交换机上直接丢掉了。

16384-16389 端口有什么玄机？

| ![viberconnection](https://cdn.v2ex.com/gravatar/dbb98ba5be1d13ea8b83daa6c233b778?s=48&d=retro) |      | 12**[viberconnection](https://www.v2ex.com/member/viberconnection)**    34 天前@[richardxy](https://www.v2ex.com/member/richardxy) 傳輸優先級別最高，即便是 QOS 也有較好的速率。「就拿我剛剛在 fast 測速的 福建電信--中華電信 舉例來說，其他 port 的速率這時多連線情形下僅僅只有 4Mbps 左右，但是這個範圍內的話可以到 100Mbps 左右，單連線的話，其他 port 這時也就只有數十 KB/s 了，而此範圍內還能到 10Mbps 以上」 |
| ------------------------------------------------------------ | ---- | ------------------------------------------------------------ |
|                                                              |      |                                                              |

https://devld.me/2020/07/27/wireguard-setup/  转发端口。

![image-20220520150229046](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653030151/2022/05/92d9ebed852a84be5bf1bf966bc0706e.webp)

通了，测试成功，需要在两边都设置iptables

测试的服务器端的wg内容如下

```Bash
root@DMZ-ubuntu-2204:/etc/wireguard# cat wg0.conf
[Interface]
Address = 172.20.0.1/24
SaveConfig = true
PostUp = ufw route allow in on wg0 out on eth0
PostUp = iptables -I FORWARD -s 172.20.0.0/24 -i wg0 -d 172.20.0.0/24 -j ACCEPT
PostUp = iptables -I FORWARD -s 172.20.0.0/24 -i wg0 -d 192.168.18.0/24 -j ACCEPT
PostUp = iptables -I FORWARD -s 192.168.18.0/24 -i wg0 -d 172.20.0.0/24 -j ACCEPT
PreDown = ufw route delete allow in on wg0 out on eth0
PostDown = iptables -D FORWARD -s 172.20.0.0/24 -i wg0 -d 172.20.0.0/24 -j ACCEPT
PostDown = iptables -D FORWARD -s 172.20.0.0/24 -i wg0 -d 192.168.18.0/24 -j ACCEPT
PostDown = iptables -D FORWARD -s 192.168.18.0/24 -i wg0 -d 172.20.0.0/24 -j ACCEPT
ListenPort = 51820
PrivateKey = 6H2sfG+W/ijv1sw1rspXPKAX+OzbtRiRZvG5EDtBtkc=

[Peer]
PublicKey = dJtTCOh36iSXO/Wyrvpd7d7MGEa/bKkTnJZeqv6sRXQ=
AllowedIPs = 172.20.0.10/32, 192.168.18.0/24
Endpoint = 49.67.189.28:1785

```

openwrt 方向需要开启各个防火墙，各个端口的转发，+ 各个端口到各个端口的内容。

同时在防火墙中所有默认的地方添加

```Bash
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -o vpn0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -j SNAT --to-source 192.168.18.2
## 说明，第一行，所有172.20.0.0 这个wg网段，源地址为这个的wg地址全部用masque的方式nat出去，走vpn0的端口（流出，！！！）
## SNAT 流出，凡是来自是172.20.0.0/24的数据，全部修改sourceSNAT到192.168.18.2 ，再经过转发。

```

###### DNAT和SNAT



这也就是说，我们要做的DNAT要在进入这个菱形转发区域之前，也就是在PREROUTING链中做，比如我们要把访问202.103.96.112的访问转发到192.168.0.112上：

iptables -t nat -A PREROUTING -d 202.103.96.112 -j DNAT --to-destination 192.168.0.112
这个转换过程当中，其实就是将已经达到这台Linux网关（防火墙）上的数据包上的destination ip address从202.103.96.112修改为192.168.0.112然后交给系统路由进行转发。
而**SNAT自然是要在数据包流出这台机器之前的最后一个链也就是**POSTROUTING链来进行操作
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source 58.20.51.66
这个语句就是告诉系统把即将要流出本机的数据的source ip address修改成为58.20.51.66。这样，数据包在达到目的机器以后，目的机器会将包返回到58.20.51.66也就是本机。如果不做这个操作，那么你的数据包在传递的过程中，reply的包肯定会丢失。

###### 同时allowedip

![image-20220520151307329](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653030791/2022/05/c25c3e31293d8b59b959b4bfa83cad9b.webp)

wg接口的peer值，只允许172.20的wg网段的值通过，全部地址伪装了。


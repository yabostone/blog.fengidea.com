---
title: "DNS分流 SmartDNS和国内外分流"
date: 2022-05-24T19:26:50+08:00
draft: false
---

双栈加上DNS和国内外分流，还是比较复杂的，和网络的多WAN口分流一样，需要不停调试。

## 工具

dig 查询，附带端口方式，要求指定解析AAAA，dig下不指定aaaa就是a。nslookup不指定就是a和aaaa都回复。

> dig @127.0.0.1 -p 5335 ipapi.co AAAA



## 测试

#### smartdns的5335端口

这个是国内分组，都是国内的dns查询。

默认可以有双栈回复。

将smartdns的第二dns的ipv6关闭。然后将5335放在Hello World的dns转发上，第一dns6054作为dnsmaq的转发。

效果：

有ipv4和ipv6优先机制（会提前ping 两个v4和v6节点看速度），部分可以分流。

由于不支持v6，所以国外的v6全部不能访问。

###### 客户机的dns

客户机不能接收默认路由下发的dns，因为有v6的dns，效果就会被破坏。

如果只有这个代路由下发的dns的话，还是没有问题的。



#### ChinaDNS-NG

这个在Bypass中，默认是支持v4和v6的，现在测试通过，

可能通过的原因是在pass下面添加强制使用daili，dns的ip

![image-20220524203931027](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653395975/2022/05/1ab0197dd966edd0a0eee375e794d7db.webp)

现在域名是解析到国内的，就是v6的ip，国外的就是v4的ip，如果有v6的国外需要，那就设置host或者不走代理？或者再看。

##### pw中

smartdns和china-ng互斥，

![image-20220524210831921](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653397714/2022/05/1d3d70ed6bd028adb1e3dd03debd9616.webp)

![image-20220524210847155](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653397729/2022/05/6c36a974817575a8c2da93718314d488.webp)

## 所以最终用Bypass+smartdns+adhome达到分流的效果

### 配置bp

1.一定要确认op上的smartdns关闭，这里出现冲突，不能两边同时开，这里占用的位置是相同的，端口相同，如果开了就没法开bp的dns。

2.在打开bp前要确认关闭smartdns。bp自带。

3.![image-20220524221408963](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653401653/2022/05/6297fa2b779d4e60c6ac07b6a9faa5e7.webp)

4.adhome 要在ipv6下方的地方点保存，不是页面最下方。

![image-20220524221705581](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653401831/2022/05/26488c4243bdf421fffd770ada126b28.webp)

5.每次更新后，要重新设置adhome，包括换服务器。所以考虑不在adHome上打开内容，而是直接配置。（先开adhome获取相关配置再不联立）。

6.检查smartdns是否没有随着bypass关闭，查看配置文件和端口，确认可用，不可用就重启。

7.DNS的流向 

**查看下/var/etc/dnsmasq.conf.cfg01411c 文件端口，流量走向 AdGuardHome->DNSMASQ->ChinaDNS-NG->SmartDNS)。**

这里dnsmasq。。。

8.重启之后好像不做任何adhome的配置都是可以的？也有v6的访问？错误，5553不可以访问，因为dnsmasq就没有支持。

9.adhome配置

![image-20220524223720573](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653403043/2022/05/84032b0e73170c67efb9ae4e5e49b3a1.webp)

上游服务器选择国内的smartdns。

可能会有dns污染的问题，但是raw.githubusercontent.com 和Google。com返回的都是可用值，不知道原因。

10.配置ipv6的允许，不需要配置私人地址（那个是用来ptr）。

![image-20220524224137892](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653403301/2022/05/f3959fe57a815ae3ca7fddaabfbef117.webp)

##### adhome的dns选择

adg的过滤规则和所接管的dns同级，
如果接管国内外网站，填国内外两种dns，会拖慢国内网址解析速度，国内dns也会抢答国外网址，比如raw.githubusercontent.com经常被运营商解析到0.0.0.0（dns污染）
只接管国内dns的话不能防止国内dns污染，不能过滤国外广告，
只接管国外网址dns不能过滤国内广告

#### 配置bp上的强制代理

添加1.1.1.1 和1.0.0.1 的强制代理。

后续如果有纯v6节点，估计也是可以直接访问的？

![image-20220524224858703](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653403741/2022/05/bf338c88f2ebe529179227fd567d1066.webp)

可配wan口的通告地址，那么如果是中继模式，dns也是用dhcp的通告值吗？

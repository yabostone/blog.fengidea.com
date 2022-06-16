---
title: "Ipv6中继路由详解"
date: 2022-06-14T12:58:48+08:00
draft: false
---

== ipv6路由中继。

> 配置ipv6下的relay
>
> https://www.aladown.com/2021/06/%E7%AE%80%E5%8D%95%E5%B9%B2%E5%87%80%E7%9A%84Openwrt-ipv6%E9%85%8D%E7%BD%AE-%E5%B1%80%E5%9F%9F%E7%BD%91WAN6%E4%B8%AD%E7%BB%A7%E6%A8%A1%E5%BC%8F%E8%8E%B7%E5%8F%96%E5%8E%9F%E7%94%9Fipv6%E5%9C%B0%E5%9D%80-%E6%97%A0%E9%9C%80PD/

今天因为更换openwr的版本，编写了ansible的配置文件，

但是dhcp的config没有添加ipv6的中继。

翻出了一个之前成功的案例。

![image-20220614130029349](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655182831/2022/06/2384dbb94e05323f79266aeaefebea56.webp)

![image-20220614130054148](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655182856/2022/06/ef806054b0c61080e85e4abdfe568b24.webp)

![image-20220614130127522](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655182888/2022/06/5be408c54a09545faf12829aacd672bd.webp)

在配置好lan和wan6的relay的基础上，还要配置

！！！ relay 在 **/etc/config/dhcp** 中配置！！！

参见![image-20220614161743119](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655194665/2022/06/735b3144626eaaad437871d7c6eef301.webp)

**全局网络选项，不配置的话默认是没有ipv6的，所以ipv6前缀必须配置。**

然后在LAN口处配置分配前缀为/64,这样默认的上级路由的分配前缀就能保留。

![image-20220614130348297](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655183030/2022/06/9a10d30b27fa00cfc55b929fc1142a97.webp)

上图是配置成功的内容，居然wan6不变化，wan4设置ipv6 的auto，lan不变化，能成功。

![image-20220614161827573](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655194709/2022/06/cac5a0915fcb088883025171359c8713.webp)

不然的话，就是LAN口WAN口设置三个relay。加上wan的master=1.



#### debian/ubuntu 配置ipv6

pve默认的lxc容器是拒绝RA的，需要变更。almaLinux也是。https://support.us.ovhcloud.com/hc/en-us/articles/360002296020-How-to-Configure-an-IPv6-Address-in-Ubuntu



![image-20220614131712928](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655183834/2022/06/59642767f7593f5b99b39b41bb1d8481.webp)

![image-20220614131639201](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655183801/2022/06/412337004fd78d09f027298679c21947.webp)

![image-20220614133301220](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655184784/2022/06/d62f454b01f925fcb88205851d3bd444.webp)

### 额外注意

**ULA 前缀开头应该是d开头。。**

重启方式为 odhcpd 重启。

```Bash
/etc/init.d/odhcpd restart

```

L2TP、IPsec可能和路由网关有关，所以没法采用socat的方式。因为上级网关是zte。


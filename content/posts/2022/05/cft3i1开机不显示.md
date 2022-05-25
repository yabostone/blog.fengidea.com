---
title: "Cft3i1开机不显示"
date: 2022-05-09T11:48:11+08:00
draft: true
---

这个电容有坏掉一个，先拆了第二个。

然后开机不加显卡无法启动，试着拆第三个。

https://www.xinxunwei.com/zbwx/082111053.html

https://www.xinxunwei.com/uploads/allimg/210821/1-210R1134542X3.png



瑞达RT1270  这里的蓄电池好像是通用的。

| 亲测不光增减网卡会变，增减显卡也会变，应该是增加、去除PCI设备都有可能引起设备序号变化，我也是因为拔掉了独显网络不通差点重装系统，幸亏搜到这里了![img](https://www.right.com.cn/forum/static/image/smiley/default/titter.gif) |
| ------------------------------------------------------------ |
|                                                              |

添加pve后，添加pcie接口的卡之后网卡改变，通过

https://forum.proxmox.com/threads/add-a-new-nic-card-ip-link-shows-the-old-nic-name-changed-but-etc-network-interfaces-still-uses-old-name.76227/

/etc/network/interfaces 是一个静态配置文件，自动更新它是个坏主意。从理论上讲，“可预测”的 systemd 网络名称无论如何都不应该改变，这更多是硬件古怪而几乎无法结合在一起的副作用。

但是，您可以为网络接口分配一个自定义名称，与 MAC 地址（或其他几个属性）匹配。有关更多信息，请参见[此处](https://wiki.archlinux.org/index.php/Systemd-networkd#Configuration_files)，示例配置：



代码：

```
# cat /etc/systemd/network/10-onboard.link
[Match]
MACAddress=xx:xx:xx:xx:xx:xx
[Link]
Name=customname0
```


您必须在 /etc/network/interfaces 中将 'enp6s0' 更改为 'customname0'，但此后不应再更改。

最好的问候，

来处理这个问题

https://forum.proxmox.com/threads/pve5-fix-those-predictable-network-interface-names.37210/

这里添加boot选项中network启动的方式。

https://www.itzgeek.com/how-tos/linux/debian/change-default-network-name-ens33-to-old-eth0-on-debian-9.html

可选关闭debian的自动命名功能。这个和pve就出现了。



q9505的机子，pve 不建议安装acpi出问题后，会将宿主机的安装磁盘的分区方式搞坏。。。

pve的lvm其实有一定的断电启动功能，断电后可以部分恢复日志，但是次数不能太多。



### 另外 

LVM需要保持余量，不能将那些空余的空间删除。。。

大家好，

我确认，使用 LVM Cache，性能比 bcache + LVM 好得多。SSD 直接存储和 LVM 缓存在我的情况下几乎没有区别，我的 VM Windows 10 在两种情况下都在 25 秒内启动（使用 bcache 是 55 秒）。我会一直这样下去，直到 ZFS Will 实现持久缓存。

谢谢大家



这里用   smartctl -i -n standby /dev/sdb |grep "mode"|awk '{print $4}'

经过测试，pve默认就是将所有的盘启动的，没法用休眠模式，现在两种方式，一种是直接拔下硬盘电源，坏了就call爸妈去换，另外一种就是组rain1.然后。。。。感觉还是拔电源合适，一直跑两个盘，到后期会陆续坏掉。



zfs需要设置最大缓存，需要添加zil

### 测试esir

测试这个版本的op包，位置 如下 https://drive.google.com/drive/folders/1rfKk3BIg-68iXAg6nC4TsbzAYh42D_pt



### 经过一个晚上的测试

发现居然是ubuntu的lxc容器不支持ipv6.

反思，需要先在ipv6默认环境测试，判断可用后再到配置的路由上测试。

添加多种环境的测试，不是单一用这个。。

![image-20220520233145544](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653060707/2022/05/95de9afe67df34404a475dc0e3e28fc4.webp)

**ipv6的路由通告居然是false**。。。我的妈呀。这和debian的自动变换网络接口的名字有什么区别啊。

https://forum.proxmox.com/threads/no-ipv6-for-lxc-container.84483/

设置容器网络为SLAAC。。不起作用

感谢 HR40，您的回复（在您编辑之前）确实帮助我解决了这个问题！我曾尝试过 SLAAC，但这也不起作用。

解决方案（针对我的环境）：

1. 将标志`IPv6AcceptRA`从更改`/etc/systemd/network/eth0.network`为。`false``true`
2. 使用`touch /etc/systemd/network/.pve-ignore.eth0.network`. （我认为）此文件阻止 PVE 主机`IPv6AcceptRA`在重新启动后将标志更改为默认值。
3. `reboot`机器或重新启动网络服务`systemctl restart systemd-networkd.service`。
4. 瞧，您的主机应该有一个 IPV6 地址！

我将此容器的 vmbridge 的网络设置保留在 IPV6 的 DHCP 上。这是一个运行 Ubuntu 20.04 LTS 的 lxc 容器。

+ 只用改一次，默认不会重置为默认值
+ 这个是PVE的包的问题，使用lxc的版本rootfs，没有问题，直接获取ipv6的值。
+ 仍然有pve的显示，不知道为什么
+ debian11 的lxc就有问题，所以暂时一段时间不用这个包。

不添加内容。。

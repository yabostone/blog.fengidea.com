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

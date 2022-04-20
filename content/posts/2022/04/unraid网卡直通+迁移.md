---
title: "Unraid网卡直通+迁移"
date: 2022-04-17T13:08:03+08:00
draft: false

---

@优先注意

远程配置时，首先需要检查网卡状态，有些网卡会在后面被使用，（用户使用了直通的网卡）

syslinux.cfg 位置

`/boot/syslinux/syslinux.cfg`

用来修改启动项

/boot/syslinux/syslinux.cfg





![image-20220417155201164](https://s2.loli.net/2022/04/17/eQT1C9Biuk86E4x.jpg)





Unraid 启动项可以直接U盘上面改。。



###### pve 的grub直通



*本帖最后由 rmrr 于 2019-8-21 14:22 编辑*  更新一下，问题已经解决 就是PVE定义网卡直通的grub文件那里增加一条语句就可以了 quiet intel_iommu=on 这条语句添加以后可以直通，但是不能拆分IUMMO组 所以只能单卡直通，就像下图那样，第二排的数字就是IUMMO分组 ![img](https://static.chiphell.com/forum/201908/21/142219fx7wt3j3e6szlgls.png)  quiet intel_iommu=on pcie_acs_override=downstream 然后在上面那个语句后面加上pcie_acs_override=downstream，就可以实现拆分IUMMO分组 就可以实现分网口直通了  ![img](https://static.chiphell.com/forum/201908/21/142219z07290zf6e66p07e.png) ![img](https://static.chiphell.com/forum/201908/21/142219vemz5lgiiaetgmsc.png)

### 使用pci vfio失败的

当然，在闪存驱动器上删除文件 /config/vfio-pci.cfg

https://forums.unraid.net/topic/93781-guide-bind-devices-to-vfio-pci-for-easy-passthrough-to-vms/

![image-20220417172043472](https://s2.loli.net/2022/04/17/apSN8v2wBhA4ynu.jpg)

测试 使用 虚拟机选项的pci部分的不安全模式失败。

不能用。

###### intel_iommu=on 这个不知道要不要写

![image-20220417183647074](https://s2.loli.net/2022/04/17/zcT7NhQyVjUtg2a.jpg)

![image-20220417185808055](https://s2.loli.net/2022/04/17/ReoQOrhXiIjM8s2.jpg)

```
lspci -vvv -s 00:02.0
```

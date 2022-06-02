---
title: "Proxmox显卡直通尝试"
date: 2022-05-09T17:49:52+08:00
draft: false

---



### tips

这里说一下为什么会需要拆分iommu `pcie_acs_override=downstream`

像我这块主板，一二槽同时插上时会共享带宽，如果不拆分iommu，当两个设备同时直通，其中一个就会显示占用

所以需要先在bios里面看设置。

+ 看看插槽是否充满

检查下bios的pcie槽有没有全开，是否有可能显卡跟m2槽的pcie通道冲突，或cpu本身在单m2加显卡的情况下pcie通道就吃满了，那种情况需要去手动降低一些插槽的速度

然后检查各类是否插紧了各条线

+ 失败，无法获取两个显卡的值，然后又有报错，不想搞了。

  

### 服务器 的q9505 主板

主板断电后不能正常启动，启动会卡住。使用的网卡启动



@@@！！！ 检查virtgl是否在host机中安装正确。

![image-20220529092551397](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653787553/2022/05/7b164ac6f9f24eb30505f34c729a4f63.webp)

查看这篇文章：https://www.owalle.com/2020/04/03/crosvm-virtio-gpu/



添加OpenGL，查看

you could use spice with virtio-gpu i guess, but you would have to put those things in the 'args' parameter
but gl acceleration will not work, we do not compile our qemu against it

also spice with gl acceleration (virgl/virglrenderer) only works (afaik) locally over a unix socket not over the network

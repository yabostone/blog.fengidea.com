---
title: "Bcache在服务器的使用"
date: 2022-07-19T11:58:02+08:00
draft: false	
---

3.10之后默认进入Linux内核。

## 配置

安装bcache-tools后。配置前需要重启！！！



配置

```Bash
make-bcache -B /dev/sda --discard -w 4KiB
make-bcache -C /dev/nvme1n1 --writeback -w 4KiB

echo /dev/sda > /sys/fs/bcache/register_quiet
echo /dev/nvme1n1 > /sys/fs/bcache/register_quiet

echo 80e5210a-1dc3-48cf-a9e7-307b0c1e0082 > /sys/block/bcache0/bcache/attach

root@e5:~# echo writeback > /sys/block/bcache0/bcache/cache_mode
root@e5:~# cat /sys/block/bcache0/bcache/cache_mode
writethrough [writeback] writearound none

echo 60 > /sys/block/bcache0/bcache/writeback_percent
## 设置60%的脏数据，就是默认60%的时候刷写数据到HDD中，0表示在1分钟内刷写ssd数据到hdd中。
echo 0 > /sys/block/bcache0/bcache/writeback_percent
```

###### 线性数据

大文件读写的cutoff

![image-20220719125423245](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658206467/2022/07/5e145c6baf3d6eda8326d8f7fa47521b.webp)

![image-20220719131021061](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658207425/2022/07/a976afcc958f99688f2946b7c1e8bc1e.webp)

测试小文件1M以下有对应的写入速度。说明缓存成功。

然后还是创建zfs吧。。

```Bash
zpool create -o ashift=12 zb /dev/bcache0  
zfs set compression=lz4 zb
```



- **碎片**：碎片是ZFS等写时复制文件系统的自然副产品。 ZFS通过使用128k的小块大小来减轻这种情况。 ZFS意向日志(ZIL)和合并写入(延迟写入)也有助于减少碎片。您可以使用`zpool status`监视碎片。但是，如果不重新格式化和还原文件系统，就无法对ZFS进行碎片整理。

首先是文件利用率，btrfs/ext3/ext4会消耗10%左右的空间作为系统消耗。如果你需要比较高的磁盘利用率，请不要考虑这三种系统。也许你会认为，放文件又不会放满，必须空出部分来才能减少文件碎片。实际上，被消耗掉的空间也并不是白白消耗，你的所有数据，都会增加10%的系统消耗空间。因此ntfs的防碎片阀值（为了防止碎片化，磁盘使用率不应当高于）大约是85%，而ext3就只有75%-80%。

![image-20220719151108252](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658214671/2022/07/0da82bb750efe0233ba01adbd78b80ba.webp)

虚拟机内速度被拉到很低，原因不明确，考虑是否将seq的bcache 设置为0。目前设置是50%，然后一开始的速度还是比较高的，4K也能跑到20MB/s，但是后面速度急剧降低，最后只有3M了。

![image-20220719151944499](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658215187/2022/07/7edde94953447e730455d9f52d7d8c97.webp)

确实有较大的影响，已经到了可以感觉到速度慢的程度了。

！！！ 换用xfs，但是这里添加了目录和fstab，如果是直接用pve自带的创建的话，如果盘失效了，不会影响其他的系统，不管是创建目录还是创建zfs盘。

=》 可以添加nofail当硬件不存在时候，仍然正常启动。

> 如果不一致，按以下步骤进行修改。
>
> 1. 将光标移到异常的参数行，按
>
>    i
>
>    键进入编辑模式，写入正确的分区信息，如下所示。
>
>    ```
>    /dev/xvdb1 /mydata ext4 defaults,nofail 0 0
>    ```
>
>    > **注意**：建议您在挂载的时候添加nofail参数，在启动实例时，若设备不存在会直接忽略它，从而不发生报错。

先测试。再判断。

xfs 效果较好，

![image-20220719155303508](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658217185/2022/07/aaa97dd822fcce40381d2965d8fba9c3.webp)

使用了RAW的文件，剩余全部置零！！！

----

！！！ 禁止跳过cache

**3. 如何防止 cache 设备成为瓶颈**

 

bcache会跟踪每个IO，如果IO的时间超过阈值，则旁路cache设备，直接读写backing设备。

 

如果你的SSD足够强大，可以不跟踪，减少跟踪的开销。

 

  \# echo 0 > /sys/fs/bcache/<cache set uuid>/congested_read_threshold_us

  \# echo 0 > /sys/fs/bcache/<cache set uuid>/congested_write_threshold_us

 

关闭旁路的另一个好处是，所有的离散读写都会经过cache设备，从而不会导致cache missing。

 

默认情况下当读请求超过2ms，写请求超过20ms时，旁路cache设备。

 

  The default is 2000 us (2 milliseconds) for reads, and 20000 for writes. 

```Bash
## 查看缓存uuid
bcache-super-show /dev/nvme1n1

## 80e5210a-1dc3-48cf-a9e7-307b0c1e0082

echo 0 > /sys/fs/bcache/80e5210a-1dc3-48cf-a9e7-307b0c1e0082/congested_read_threshold_us

echo 0 > /sys/fs/bcache/80e5210a-1dc3-48cf-a9e7-307b0c1e0082/congested_write_threshold_us

```

!!! 设置强制小文件缓存到ssd后平均响应时间急剧减小了，（zfs应该也是，不过zfs的4k性能实在太差了，

![image-20220719170556801](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1658221561/2022/07/d3fbb9d1f29c928e66e6c58a606e32ca.webp)

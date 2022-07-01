---
title: "WAN口环境拉取和推送数据"
date: 2022-06-25T14:38:15+08:00
draft: false	
---

== 这是一个很老的话题了。

## 使用rclone

使用rclone ，服务端搭建http或者webdav，然后客户端拉取数据，这个方式速度最快，但是有缺陷，就是占用cpu较高。同时像union，syncthing，要么速度慢，要么是字节检测。不适合自己的场景。

这次考虑更换方式。



## 使用多线程的rsync

#### 以前自建脚本

用过ssh连接，find 在远端机器生成files类型文件，再远端拉取数据。

现在脚本没找见，试试其他的。

#### 使用parallel

可用parallel或者xargs 作为多次命令输入查询

parallel -j {number} number用来限制rsync的最多启动数量

或者可用find . 查询，使用占位符，这里有delete 需要小心。

！！！ 注意是本地推送到远程。

> find -L -type f | parallel -j 8 -v rsync -razHXSR --ignore-errors --stats --info=progress2 --delete {} /目的端地址

#### 使用parsyncfp

http://moo.nac.uci.edu/~hjm/parsync/

结合fpart部分，	fpart的前身。

> pfp 只需要安装在传输的 SOURCE 端，并且只能在本地 SOURCE -> remote TARGET 模式下工作（它不允许远程本地 SOURCE <- remote TARGET，如果尝试，会发出错误并退出）。它要求在操作之前设置 ssh 共享密钥，[请参见此处](https://goo.gl/ghCazV)。如果它检测到 ssh 密钥设置不正确，它将请求许可以尝试纠正这种情况。检查您的本地和远程 ssh 密钥以确保它已正确完成。通常，它们位于您的 ~/.ssh 目录中。

#### 使用fpart

fpart下面有对应的fpsync，可以使用。

注意格式，这里也是只能推送，无法src是远程端。

**可以考虑用tailscale。。。**(发现tailscale 也会大量占用cpu，大概能发到360Mbps的数据，实际接受24MB/s,还是有一定的损耗的。)

考虑到CPU占用，实际使用http或者webdav更方便些。

！！！ 更新，尝试了webdav，结果cpu完全打满，后限速到80Mbps，tailscale高峰有接近360mbps，就是解包占用流量较多。

**最后测试后决定tailscale加上fpsync 走一波，次之考虑rclone 的http或者webdav。**



```Bash
# Check if $1 is a valid rsync URL
# Cf. rsync(1) :
#   SSH:   [USER@]HOST:DEST
#   Rsync: [USER@]HOST::DEST
#   Rsync: rsync://[USER@]HOST[:PORT]/DEST
# Simplified as: "anything but slash" followed by at least one ":"
```



```Bash
fpsync  -vvv -o '-avm --numeric-ids --safe-links' -n 10 /etc/ /root/rsyncexp
#### 这里的可以用，一般会有errors，需要第二轮
fpsync  -vvv -o '-avmr --numeric-ids --safe-links --password-file=/etc/rsyncpasswd ' -n 16  /home/mxuan/torrents/qbittorrent/ admin@100.125.250.65::B2/MKV/et8-1/

```

#### 使用python的wrapper



```Bash
from parallel_sync import rsync                                                 
                                                                                
creds = {'user': 'root', 'key':'/root/.ssh/id_rsa', 'host':'168.235.72.82'}     
                                                                                
rsync.download('/home/mxuan/torrents/qbittorrent/', '/data/', creds=creds)
```

这里测试时候，没有流量判断，而且上面有显示rsync连接失败，具体的不明确，有些不敢用。。

第二次使用时候，提示no dir。不知道原因



## 小结

+ 使用qbox，ssh默认开启密码登录，有很多人在扫22端口，**出现了将/root文件夹变更到1024:user 权限的情况。然后ssh就无法登录了。**

排查了好久才排查出来，

+ tailscale的两方都需要进行加密解密，跑到24MB/s 的情况下，j3150的CPU占用80%s，ramnode的cpu占用80% （2G的存储型kvm）
+ 流量上400mbps的流量出，到解包之后只有200mbps，不知道丢包率。。

+ 如果本地跑的机子能够开22端口跑rsync，那么就是跑的最佳方案了。。

+ 国内的pt站，挂载到国外效率低，应该侧重增加国内机子的上传带宽。


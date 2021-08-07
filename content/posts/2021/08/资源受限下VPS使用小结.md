---
title: "资源受限下VPS使用小结"
date: 2021-08-01T12:10:49+08:00
tags:
  - VPS
  - Shell
categories:
  - VPS
draft: false
---

### 在资源受限下VPS使用

资源受限下，如RAM不足，会导致`kswapd0`命令CPU进程上升，而VPS会对CPU占用时间长的命令自动杀死，导致qbittorrent命令被kill，迫使自动重校验。

安装了aria2，docker，rclone，qbittorrent，rtorrent后RAM资源不足，所以不能安装这么多。



#### 软链接删除错误

在复合使用中使用了软链接，这里在磁盘容量够的情况下优先使用`rsync` 或`cp`命令，次之适合用`ln`命令，删除软链接时，不能加 `\` ,如 `rm -rf \home\soft\` 是删除软链接下的文件夹中的文件，`rm -rf \home\soft` 是删除这个软链接。


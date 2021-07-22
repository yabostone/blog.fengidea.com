---
title: "图片压缩magick"
date: 2021-07-22T17:43:12+08:00
tags:
  - 建站
categories:
  - 技术
draft: false
---



#### 图片压缩
如果选择用CDN的话，有专门的代码和管道来进行压缩，不过在本地压缩一遍再上传也是不错的选择，这里不使用腾讯的CDN而是选择压缩后直接放到static文件夹下，使用magick命令。magick命令是十分有名的图片处理命令行程序，安装后，我们直接用quality命令进行压缩。

	magick -quality 50 1.jpg 2.jpg

这样可以很好的控制压缩比例。


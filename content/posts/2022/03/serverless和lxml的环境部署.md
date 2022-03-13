---
title: "Serverless和lxml的环境部署"
date: 2022-03-13T10:59:00+08:00
draft: false
tags:
  - serverless
  - 运维
categories:
  - serverless

---

### serverless的环境部署



今日用serverless 搭建了个小型监控报警系统。

有几个需要注意的点。

+ python需要 用 

  ```
  pip install -r requirements.txt -t . 
  ```

  来将依赖完成在目标文件夹，其中有些依赖需要相同版本的python，和相同的环境（win，manylinux）。如lxml，

  在python3.7版本，总是有lxml的etree无法使用，就是因为lxml强依赖于python版本，所以用linux下的不同python版本做pip是没有用的。

  这里使用了vscode的container环境搭建一个python3.9版本的ubuntu环境，其中python3.9是手动用源码编译的，这样才能满足requirements的要求。

+ 在serverless环境下，还是Java的版本依赖可以做的更好，毕竟只需要打好的jar包就可以了。
+ 文件存储还是需要oss存储，没法使用本地文件，提示权限不够。
+ serverless还是有很多的依赖问题，不过放在虚拟机环境也是有相同的问题，只有用docker才能有良好的一致环境。
+ 没有使用serverless-dev等一系列的开发环境，可能有所欠缺，代码部署选择手动代码上传。
+ oss可以使用内网的环境。只要修改endpoint就好了。

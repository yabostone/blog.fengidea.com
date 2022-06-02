---
title: "Docker的作业相关"
date: 2022-05-06T11:53:20+08:00
draft: false

---

给接的闲鱼单的作业做个小备忘

### 阿里云镜像

```Bash

基本信息
仓库名称
zhangdingmu2033
仓库地域
华东1（杭州）
仓库类型
公开
代码仓库
无
公网地址
registry.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
registry.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
复制
专有网络
registry-vpc.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
registry-vpc.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
复制
经典网络
registry-internal.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
registry-internal.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033
复制
摘要
For edu
操作指南
制品描述
1. 登录阿里云Docker Registry
$ docker login --username=zhangdingmu2033 registry.cn-hangzhou.aliyuncs.com
用于登录的用户名为阿里云账号全名，密码为开通服务时设置的密码。

您可以在访问凭证页面修改凭证密码。

2. 从Registry中拉取镜像
$ docker pull registry.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033:[镜像版本号]
3. 将镜像推送到Registry
$ docker login --username=zhangdingmu2033 registry.cn-hangzhou.aliyuncs.com
$ docker tag [ImageId] registry.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033:[镜像版本号]
$ docker push registry.cn-hangzhou.aliyuncs.com/zhangmingmu2033/zhangdingmu2033:[镜像版本号]
请根据实际镜像信息替换示例中的[ImageId]和[镜像版本号]参数。

4. 选择合适的镜像仓库地址
从ECS推送镜像时，可以选择使用镜像仓库内网地址。推送速度将得到提升并且将不会损耗您的公网流量。

如果您使用的机器位于VPC网络，请使用 registry-vpc.cn-hangzhou.aliyuncs.com 作为Registry的域名登录。

5. 示例
使用"docker tag"命令重命名镜像，并将它通过专有网络地址推送至Registry。

$ docker images
REPOSITORY                                                         TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
registry.aliyuncs.com/acs/agent                                    0.7-dfb6816         37bb9c63c8b2        7 days ago          37.89 MB
$ docker tag 37bb9c63c8b2 registry-vpc.cn-hangzhou.aliyuncs.com/acs/agent:0.7-dfb6816
使用 "docker push" 命令将该镜像推送至远程。

$ docker push registry-vpc.cn-hangzhou.aliyuncs.com/acs/agent:0.7-dfb6816
```

## docker 密码和aliyun的密码

> zhangxxx
>
> 123456zzz

### 这条命令居然直接进入容器

>  docker run -it --rm -v $(pwd):/code --name ubuntu ubuntu:latest

![微信图片_20220513171449](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652433334/2022/05/372d31be12f291cf9fd3237159843825.webp)

```Bash
{“name”:”zhangsan”,”age”:”20”,”score”:”80”},
{“name”:”lisi”,”age”:”21”,”score”:”85”},
{“name”:”wangwu”,”age”:”20”,”score”:”90”},
{“name”:”Zangwu”,”age”:”20”,”score”:”90”},
{"name":”zhaoliu”,”age”:”22”,”score”:”80”}
```

这里写作业需要调整图片大小。

需要用word，wps需要会员，

1.添加图片要到ribbon界面添加图片，才能保证顺序一致。

2.到![image-20220513204013486](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652445616/2022/05/9f6d2f6817ef6990b2aaffc88b567c16.webp)

![图像 212](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652445698/2022/05/cdf654147fd42786e8bd3d7de2e80cac.webp)

上面的1.2.3步，到宽度处改成11cm，然后点**下一个图片点F4即可。**



```Bash
db.student.mapReduce(

function() {emit(this.score, {"score":this.score,count:1})},
function(score, values) {
var total = 0;
  for (var i = 0 ; i < values.length;i++){
    total += values[i].count;
  }
  return {count:total}
},
{
         query:{age:"20"},  
         out:"student_scores"
}
)
进行了分组，然后是按照分数分的。

```

![image-20220514194114784](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1652528476/2022/05/abb198b2b7958ffa635c0fa5f7a37039.webp)

### docker 大作业

    8  ls
    9  vim /etc/profile
   10  mvn -v
   11  cd ~
   12  mvn archetype:generate -Dgroupid=org.examples.java -DartifactId=helloworld
   13  mvn archetype:generate -DgroupId=org.examples.java -DartifactId=helloworld
   14  vim ~/.m2/settings.xml
   15  nano ~/.m2/settings.xml
   16  ls -ahl
   17  nano ~/.m2/settings.xml
   18  mvn archetype:generate -DgroupId=org.examples.java -DartifactId=helloworl
   19  tree .m2/
   20  ls
   21  cd helloworl/
   22  ls
   23  mvn package
   24  java -co target/helloworl-1.0-SNAPSHOT.jar org.examples.java.app
   25  java -cp target/helloworl-1.0-SNAPSHOT.jar org.examples.java.app
   26  java -cp target/helloworl-1.0-SNAPSHOT.jar org.examples.java.App
   27  docker container:run -it openjdk:8
   28  docker run -it openjdk:8
   29  history
[huangliuyan1237@centos7 helloworl]$



 git clone https://ghproxy.com/https://github.com/arun-gupta/docker-java-sample

mvn -f docker-java-sample/pom.xml install -Pdocker


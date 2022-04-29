---
title: "Kubeless搭建和minikube使用"
date: 2022-04-13T21:36:20+08:00
draft: false
tags:
  - 运维
categories:
  - 运维
---





#### 一些链接

http://liubin.org/blog/2021/01/28/install-old-version-k8s/ 

安装老版本k8s

#### 安装docker

```Bash
curl -sSL  get.docker.com | sh

```





##### 需要不适用root登录（测试失败）

这里还有一个问题需要注意一下，如果你是使用的 root 账号操作的话，会有一个问题，minikube 不能以 root 权限启动，需要创建一个其他用户然后切过去，不过这个用户是无法通过 docker 客户端跟服务端 `/var/run/docker.sock` 连接的，因为这个socket是 root 创建的，所以我们对应的也要给予这个用户访问 docker 的权限，这里我们以创建一个叫 developer 的用户为例：

```shell
# 创建用户
sudo adduser developer

# 创建组 docker
sudo groupadd docker

# 把 developer 加到 docker 这个组里面去
sudo usermod -aG docker developer

# 重启 docker，使得 /var/run/docker.sock 的用户组变更
sudo systemctl restart docker.socket docker

# 然后切过去验证一下
su developer
docker ps
```

来自 https://huweicai.com/minikube-install-tutorial/

```Bash
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.15.1/minikube-linux-amd64
chmod +x minikube && sudo mv minikube /usr/local/bin/
```

https://huweicai.com/minikube-install-tutorial/ 目前这个文件比较合适。

国内镜像

```Bash
minikube start --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --image-mirror-country=cn

```



![image-20220413220141196](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/9555446b323cbf42f07a6b189bc58af5.png)

https://minikube.sigs.k8s.io/docs/start/

尝试root下安装，为 none !!! **需要在root目录下执行命令**

**需要先**

```Bash
sudo apt-get install -y conntrack

```



再start  

```Bash
minikube start --vm-driver=none  
```



![image-20220413221040721](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/326a87309fe633d51fc40d1dba4bf725.png)

设置 默认alias

```Bash
alias kubectl="minikube kubectl --"

测试 kubectl 版本对应

```

测试可用

https://kubernetes.io/zh/docs/tutorials/hello-minikube/

1. ```shell
   kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
   ```

1. 

2. ```shell
   kubectl get deployments
   ```



1. ```shell
   kubectl get events
   ```

1. 

1. ```shell
   kubectl config view
   ```

```shell
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
```

![image-20220413221820044](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/3894875a56f6eecaaa9c2d54c13972c1.png)

自动补全

```Bash
echo "source <(kubectl completion zsh)" >> ~/.bashrc
echo "alias kubectl="minikube kubectl --"" >> ~/.bashrc
```



##### dashboard

```Bash
minikube dashboard --port=33405
自建转发

```



设置本地的端口转发

！！！注意本地端口转发需要设置sshkey ，

第一步填![image-20220413222744872](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/f4938690a3e1f38f36199bcfd45adb6d.png)

![image-20220413222809339](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/35beac6434fb4af9b35054f988714606.png)

设置ssh-key

##### 安装kubeless

![image-20220413223257640](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/536ffa564272ebf14822128daf622943.png)

```Bash
wget https://github.com/vmware-archive/kubeless/releases/download/v1.0.8/kubeless_linux-amd64.zip

unzip kubeless.zip
sudo cp bundles/kubeless_linux-amd64/kubeless /usr/local/bin/
```

#### 需要是启动RBAC的

```Bash
kubectl create ns kubeless 
kubectl create -f https://github.com/kubeless/kubeless/releases/download/v1.0.8/kubeless-v1.0.8.yaml
```



查看是否运行

```Bash
kubectl get pod memory-demo --namespace=mem-example
kubectl get pods --namespace=kubeless

```

![image-20220413224526546](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/0246cb8ab9ed49c32ee28f95b1952329.png)

```Bash

kubectl get pods -n kubeless
NAME                                   READY     STATUS    RESTARTS   AGE
kafka-0                                1/1       Running   0          1m
kubeless-controller-3331951411-d60km   1/1       Running   0          1m
zoo-0                                  1/1       Running   0          1m

kubectl get deployment -n kubeless
NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kubeless-controller   1         1         1            1           1m

kubectl get statefulset -n kubeless
NAME      DESIRED   CURRENT   AGE
kafka     1         1         1m
zoo       1         1         1m

kubectl get customresourcedefinition
NAME             DESCRIPTION                                     VERSION(S)
function.k8s.io   Kubeless: Serverless framework for Kubernetes   v1

kubectl get functions
```

编写代码

```Bash
import urllib2
import json

def find(request):
    term = request.json["term"]
    url = "https://feeds.capitalbikeshare.com/stations/stations.json"
    response = urllib2.urlopen(url)
    stations = json.loads(response.read())

    hits = []

    for station in stations["stationBeanList"]:
        if station["stAddress1"].find(term) > -1:
            hits.append(station)

    return json.dumps(hits)
```

来自网页https://docs.bitnami.com/tutorials/get-started-serverless-computing-kubeless/

#### demo测试

https://github.com/eldada/kubeless-demo

`git clone https://github.com/eldada/kubeless-demo`

到目录后按照readme操作

例如java的demo，会拉取两次镜像和编译。。

大概几百兆。

测试时候，用trigger和相关测试。

![image-20220413233139737](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/500c7e48dc3d16d674b77ed4ccd82a49.png)

![image-20220413233204227](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/93840c3a0a4ec9c0906b16c56864647b.png)


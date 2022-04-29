---
title: "Oracle下的k8s搭建"
date: 2022-04-25T13:05:07+08:00
draft: true
---

搭建k8s

### 防火墙

![image-20220425140205206](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650866537/2022/04/b94ab8cff7f52ba605fc41ca675b201d.webp)



现在要在10。x.x.x下开启全部端口，出现了问题

使用root域，成功



##### ubuntu root登录

> root  passwd  abc123456

在root文件夹下删除对应的输出 no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"ubuntu\" rather than the user \"root\".';echo;sleep 10"

留下sshkey

>  vim /root/.ssh/authorized_keys

%s/prohibit-password/yes/

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGDsAj/YvsaMGUI03zpgsIyvejBxKEm76K+0BNKZ5dekxwXcXG5e4I+JEUH14ao563d9S2zXEZ3sHMqkK5XW7m8D0689PXuEOG1vXO/RLizgWfdRAPkh+TCWRvKpqg3qycHi+aVhnGSCDj0dDq1uF840NThVq/tQi/sSd5UjFyI5B7e9wZYoHg61AgO9RPQytF2zDl4kHwY/E5DxtlnHCRIfsy6u+qPArddWYVllWZaV/8MInjUdG0bdGFQtOzqGHTWoJjcGA/1oPmXcftR+Kfqn3j5ffiUa4PtO0yB/JJUvu18oQce3y/p5F0tUYLLiN/KsfLt9KSkav7dSeNhZO1 ssh-key-2022-04-24

> 1  passwd root
>     2  vim /etc/ssh/sshd_config
>     3  vim /root/.ssh/authorized_keys
>     4  systemctl restart ssh
>     5  history



不安装kube dashboard 看这篇：

https://kuboard.cn/install/install-k8s-dashboard.html#%E8%AE%BF%E9%97%AE



不安装dashboard

https://github.com/kubernetes/dashboard



```sh
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
执行获取token


```

### 删除dashboard不终止

修改spec

https://www.cnblogs.com/xiao987334176/p/13272410.html



curl -k -H "Content-Type:application/json" -X PUT --data-binary @kubesphere-system.json http://127.0.0.1:8081/api/v1/namespaces/kubernetes-dashboard/finalize

##### 将dashboard改成nodeport就可以外网访问

https://www.qikqiak.com/k8s-book/docs/17.%E5%AE%89%E8%A3%85%20Dashboard%20%E6%8F%92%E4%BB%B6.html



### 注意etcd节点的安装

https://kuboard-spray.cn/guide/maintain/add-replace-node.html#%E6%B7%BB%E5%8A%A0-etcd-%E8%8A%82%E7%82%B9

```
sudo rm -rf /var/lib/etcd2/* 
sudo rm -f /etc/systemd/system/etcd* 
```

问题节点的etcd可能需要删除。

yaml的文件

​	

查看yaml

kubectl get po nginx-deployment-86c9897b69-r8dcp -o yaml

存储后名字更新

[root@master1 ~]# kubectl replace -f rc-nginx.yaml



## 使用do安装

```yaml
[control_plane]
control1 ansible_host=control_plane_ip ansible_user=root 

[workers]
worker1 ansible_host=worker_1_ip ansible_user=root
worker2 ansible_host=worker_2_ip ansible_user=root

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

**Warning ： 确保可用域和容错域完全相同，再配置iptables。。。**

![image-20220425223330657](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650897213/2022/04/1b7e62196512076c3f48dbadf5afd4fc.webp)

三个节点都需要关闭iptables。否则不能互通。

```Bash
iptables -P INPUT ACCEPT 
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT 
iptables -F
```

## 总结

### oracle

需要将三个节点的容错域和源域设置成相同的。

需要去掉iptables，

需要设置域到root下面。

### 需要pod



```Bash
python3 -m http.server 

然后访问：8000端口看是否可以访问。
```

### do的安装ansible

https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-20-04



### 调测

​	下面代码好像验证失败

```Bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 3 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
```



##### 缩放

## 缩放 Deployment 

你可以使用如下指令缩放 Deployment：

```shell
kubectl scale deployment/nginx-deployment --replicas=10
```

输出类似于：

```
deployment.apps/nginx-deployment scaled
```

https://kubernetes.io/zh/docs/concepts/workloads/controllers/deployment/

https://kubernetes.io/zh/docs/tasks/run-application/run-stateless-application-deployment/

创建更新副本等。

#### 暴露services

https://kubernetes.io/zh/docs/concepts/services-networking/connect-applications-service/

> ```shell
> kubectl expose deployment/nginx-deployment
> ```

![image-20220425232849430](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650900531/2022/04/99a929964a3b99768630bb213e08d9cf.webp)

![image-20220425232922432](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650900564/2022/04/79197892c0f790f52a6f137211b90550.webp)

> kubectl get svc nginx-deployment
>
> kubectl get svc 
>
> 现在可以在内网中访问对应端口
>
> root@minikube:/home/ubuntu# kubectl edit services nginx-deployment
> service/nginx-deployment edited

将CLusterIP改为NodePort 对外暴露，然后查看对应的端口是多少，端口范围默认是有限制的。



![image-20220425233725848](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650901047/2022/04/1145d4128a90aa4cc44ae1ada17c8bf4.webp)

![image-20220425233842874](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650901124/2022/04/32af150a493ba7f6faed40ed601b0316.webp)

nodePort暴露，

同时还可以给 service 指定一个 `nodePort` 值，范围是 30000-32767，这个值在 API server 的配置文件中，用 `--service-node-port-range` 定义。

设置apiserver配置文件

https://kuboard.cn/install/faq/apiserver-params.html



Ingress

https://doc.traefik.io/traefik/providers/kubernetes-ingress/

https://kubernetes.github.io/ingress-nginx/deploy/

##### 大作业要求

o automate your experimentation and collect data points, you can write a script that
automatically varies the parameters for the experiments and collects data points



#### 访问pods的logs

Finally, show the log for pods to demonstrate load balancing is working as expected

use 

```Bash
kubectl logs nginx-xxxx

```

在进阶用法中，我们可以通过Prometheus和 Grafana记录logs日志，在这里由于时间关系，不做此说明和配置。



![image-20220426082542703](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650932750/2022/04/cf131d01a0fcb501c308764095c44a88.webp)

##### ingress

跳过。。。

### 修改kube-apiserver.yaml

使用 kubeadm 安装 K8S 集群的情况下，您的 Master 节点上会有一个文件 `/etc/kubernetes/manifests/kube-apiserver.yaml`，修改此文件，向其中添加 `--service-node-port-range=80-22767` （请使用您自己需要的端口范围），如下所示：

修改services 

nodePort 端口设置为 80

**成功**

##### 删除资源

```Bash
kubectl delete -f ./pod.json                                              # 删除在 pod.json 中指定的类型和名称的 Pod
kubectl delete pod,service baz foo                                        # 删除名称为 "baz" 和 "foo" 的 Pod 和服务
kubectl delete pods,services -l name=myLabel                              # 删除包含 name=myLabel 标签的 pods 和服务
kubectl -n my-ns delete pod,svc --all                                     # 删除在 my-ns 名字空间中全部的 Pods 和服务
# 删除所有与 pattern1 或 pattern2 awk 模式匹配的 Pods
kubectl get pods  -n mynamespace --no-headers=true | awk '/pattern1|pattern2/{print $1}' | xargs  kubectl delete -n mynamespace pod
```

​	

#### python 检测

```Bash
python iWebLens_client.py  inputfolder/  http://127.0.0.1:5000/api/object_detection 4
```

![image-20220426091932217](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650935977/2022/04/b194a77b5362bdf54cd76e86efad6f1c.webp)

四个线程跑。

获取了响应时间，这里基本完成了。

![image-20220426123940304](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650947984/2022/04/79a1669de9d18900f97c1c68f5181d45.webp)

![image-20220426124040113](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650948042/2022/04/fc91e05011aff733a94cfaba599e82a5.webp) 

所以需要将

![image-20220426124254444](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650948177/2022/04/ae4c451b63bee7f618e55da126b7b45b.webp)

这里希望写一个bash脚本来获取相关信息值。然后存储。

Legend 代表图形里面的内容，所以是一张图，多个折线，反应值。

返回平均响应时间。

获取响应时间的内容

```Bash
cat re1p40.log | awk 'END {print}' | awk -F " " '{print $8}'
0.04807143285870552
```

思路，测试每个按照流程来，1pods

参见

https://blog.csdn.net/roguesir/article/details/77839721的plot书写方法



符号，颜色

https://blog.csdn.net/qq_40260867/article/details/95310956



#### 测试ansible

```Bash
[control_plane]
control1 ansible_host=168.138.11.233 ansible_user=root 

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

```Bash
ansible  controll --key-file "ssh-key-2022-04-24.key" -m shell -u root  -a 'ls'
kubectl 是/etc/ansible/hosts 下定义的分组。
这里选定了分组kubectl。
然后sshkey需要是自己的权限
chown -R vscode:vscode ssh-key.key

```

#### python代码注意

默认遍历循环列表时，不会对列表进行操作，for ptr in listlist：

生成的ptr是个新值，只有用 for ptr in range(len(listlist)):

listlist[ptr]/=3 操作，才能使列表内部的元素变更。



### metaLB搭建

https://makeoptim.com/service-mesh/kubeadm-kubernetes-istio-setup#metallb

需要单节点部署

https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#a-pure-software-solution-metallb

nginx-ingress 官方写法



### 简单创建nginx服务

![image-20220428104026861](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651113628/2022/04/a6c573c2ea1dd33a65824543c8e47b58.webp)

https://atbug.com/load-balancer-service-with-metallb/ 

metallb的创建configmap过程

![image-20220428104139638](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651113701/2022/04/470cc2402abad1e3fe96cc04901b061b.webp)

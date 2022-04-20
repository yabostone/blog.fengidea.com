---
title: "Openfaas在k8s下面的安装"
date: 2022-04-13T23:24:51+08:00
draft: true
---



#### minikube下安装

https://faun.pub/getting-started-with-openfaas-on-minikube-634502c7acdf

需要安装helm

#### arkade安装

https://github.com/alexellis/arkade

```Bash
curl -sLS https://get.arkade.dev | sudo sh

```



arkade 安装terraform ,

```Bash
arkade get terraform
arkade install redis
//可以快速安装go ，redis ，terraform ，和helm上的部分程序

```

```Bash
arkade get kubectl@v1.15.1
安装相同版本的kubectl ，k8s有版本要求
sudo mv /root/.arkade/bin/kubectl /usr/local/bin/
安装arkade
arkade get faas-cli
sudo mv /root/.arkade/bin/faas-cli /usr/local/bin/


直接安装，不要填写其他信息，测试直接安装成功
arkade install openfaas
```

![image-20220413234542839](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/c50804b287ed5d78999be109d1481257.png)

##### 测试是否安装完成

信息可由 获取

```Bash
arkade info openfaas

```







```Bash
  kubectl -n openfaas get deployments -l "release=openfaas, app=openfaas"

```

```Bash
=======================================================================
= OpenFaaS has been installed.                                        =
=======================================================================

# Get the faas-cli
curl -SLsf https://cli.openfaas.com | sudo sh

# Forward the gateway to your machine
kubectl rollout status -n openfaas deploy/gateway
kubectl port-forward -n openfaas svc/gateway 8080:8080 &
### 替代失败，需要节点有socat才能转发，需要将之前的8080端口放开

kubectl port-forward -n openfaas svc/gateway 18080:8080 &
# If basic auth is enabled, you can now log into your gateway:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin

faas-cli store deploy figlet
faas-cli list

```



#### kind 介绍

[kind](https://sigs.k8s.io/kind)是一个使用 Docker 容器“节点”运行本地 Kubernetes 集群的工具。
kind 主要是为测试 Kubernetes 本身而设计的，但也可以用于本地开发或 CI。

如果你有[go](https://golang.org/) ( [1.17+](https://golang.org/doc/devel/release.html#policy) ) 并且安装了[docker](https://www.docker.com/)`go install sigs.k8s.io/kind@v0.12.0 && kind create cluster`就是你所需要的！

对于旧版本，请使用`GO111MODULE="on" go get sigs.k8s.io/kind@v0.12.0`.

#### dashboard 现在需要秘钥

![image-20220414075804997](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/e8410a6767b82215aeb83367aa341c3a.png)

#### 设置ingress

如果您在 AKS 或 GKE 等云上运行，则需要传递一个额外的标志`--set serviceType=LoadBalancer`来指示`helm`创建 LoadBalancer 对象。使用多个 LoadBalancer 的替代方法是安装一个 Ingress 控制器。

### 使用 IngressController 部署

为了使用自动入口设置，您需要集群中的 IngressController，例如 Traefik 或 Nginx。

添加以在通过运行安装时`--set ingress.enabled`启用入口通行证。`--set ingress.enabled=true``helm`

默认情况下，服务将使用以下主机名公开（可以更改，有关详细信息，请参阅 values.yaml）：

- `gateway.openfaas.local`

#### cli with node

https://docs.openfaas.com/tutorials/cli-with-node/

https://docs.openfaas.com/tutorials/first-python-function/

#### 端口转发

先安装socat 

```Bash
apt install socat

```

```Bash
root@instance-5:/home/OpenSSH-rsa-import-020919# kubectl get service gateway -n openfaas
NAME      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
gateway   ClusterIP   10.97.200.50   <none>        8080/TCP   39m
root@instance-5:/home/OpenSSH-rsa-import-020919#

```

用了port-forwarding 不成功，还是没有外部ip。port-forward只是本地转发。

查看面板上的端口，发现Nodeport已开启

查看yaml文件发现

```Bash
spec:
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 31112
  selector:
    app: gateway
  clusterIP: 10.97.22.214
  type: NodePort
  sessionAffinity: None
  externalTrafficPolicy: Cluster
status:
  loadBalancer: {}

```

端口号为 31112 于是访问对应值。

#### 何时使用这种方式？

这种方法有许多缺点：

1. 每个端口只能是一种服务
2. 端口范围只能是 30000-32767
3. 如果节点/VM 的 IP 地址发生变化，你需要能处理这种情况。

#### 外部IP

```
spec:
  clusterIP: 10.107.169.79
  externalIPs:
  - 192.168.96.10
  ports:
  - port: 80
    protocol: TCP
    targetPort: web-port
```

#### 本地访问

1. 检查部署的推出状态`gateway`：

```bash
kubectl rollout status -n openfaas deploy/gateway
```

以下示例输出显示`gateway`部署已成功推出：

```
deployment "gateway" successfully rolled out
```

1. 使用该`kubectl port-forward`命令将向[http://localhost:8080](http://localhost:8080/)发出的所有请求转发到运行该`gateway`服务的 pod：

```bash
kubectl port-forward -n openfaas svc/gateway 8080:8080 &
[1] 78674
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

请注意，与号 ( `&`) 在后台运行该进程。您可以使用该`jobs`命令显示后台进程的状态：

```bash
jobs
[1]  + running    kubectl port-forward -n openfaas svc/gateway 8080:8080
```

#### URL

1. 使用`faas-cli list`命令列出部署到本地 OpenFaaS 网关的功能：

```bash
faas-cli list
Function                      	Invocations    	Replicas
appfleet-hello-world          	0              	1
```

☞ 请注意，您还可以通过提供网关的 URL 列出部署到不同网关的功能，如下所示：

```bash
faas-cli list --gateway https://<YOUR-GATEWAT-URL>:<YOUR-GATEWAY-PORT>
```

1. 您可以使用该`faas-cli describe`方法检索有关该`appfleet-hello-world`函数的更多详细信息：

```bash
faas-cli describe appfleet-hello-world
```

#### 调用

## 使用 CLI 调用您的无服务器函数

1. 要查看您的无服务器功能，请发出`faas-cli invoke`命令，指定：

- `-f`带有描述函数的 YAML 文件名称的标志( `appfleet-hello-world.yml`)
- 您的函数名称 ( `appfleet-hello-world`)

```bash
faas-cli invoke -f appfleet-hello-world.yml appfleet-hello-world
Reading from STDIN - hit (Control + D) to stop.
```

1. 键入`CTRL+D`。以下示例输出显示您的无服务器函数按预期工作：

```
appfleet
Handling connection for 8080
{"status":"done"}
```

#### 看看UI是否可用

1. Install the [OpenFaaS CLI](https://github.com/openfaas/faas-cli) (I did `brew install faas-cli` on my Mac)

2. Install OpenFaaS — I used the [Helm charts](https://github.com/openfaas/faas-netes/blob/master/HELM.md). (At time of writing that required me to [create an additional ClusterRole](https://github.com/openfaas/faas-netes/issues/59) for the FaaS Controller, and then the Helm charts worked fine).

3. Find the OpenFaas Gateway:

4. ```Bash
   minikube service list
   ```

5. 

```
$ minikube service list
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| default     | alertmanager         | No node port                |
| default     | alertmanager-external| http://192.168.99.100:31113 |
| default     | faas-netesd          | No node port                |
| default     | faas-netesd-external | http://192.168.99.100:31111 |
| default     | gateway              | No node port                |
| default     | gateway-external     | http://192.168.99.100:31112 |
| default     | kubernetes           | No node port                |
| default     | prometheus           | No node port                |
| default     | prometheus-external  | http://192.168.99.100:31119 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | http://192.168.99.100:30000 |
| kube-system | tiller-deploy        | No node port                |
|-------------|----------------------|-----------------------------|
```

Browse to the gateway-external address and you’ll see the OpenFaas UI.

![img](https://miro.medium.com/max/1400/1*8yo6maTprqGa7WePXfUa2A.png)

You can also point the `faas-cli` at the gateway-external address, for example:

```
$ faas-cli list — gateway http://192.168.99.100:31112/
Function Invocations Replicas
```

For now this doesn’t show anything interesting because I haven’t created any functions. But let’s fix that.

OpenFaaS 提供基于 Web 的用户界面。在本节中，您将了解如何使用它来部署无服务器功能。

1. 首先，您必须使用以下`echo`命令来检索您的密码：

```bash
echo $PASSWORD
49IoP28G8247MZcj6a1FWUYUx
```

1. 打开浏览器并访问[http://localhost:8080](http://localhost:8080/)。要登录，请使用`admin`您在上一步中检索到的用户名和密码。您将被重定向到 OpenFaaS 主页。选择*部署新功能*按钮：

1. 将显示一个新窗口。选择*自定义*选项卡，然后键入：

- `docker.io/andreipopescu12/appfleet-hello-world`在*Docker Image*输入框中
- `appfleet-hello-world`在*函数名称*输入框中

#### nginx 公开端口

- 使用Ingress Controller
  - Ingress 不会公开任意端口或协议。 将 HTTP 和 HTTPS 以外的服务公开到 Internet 时，通常使用 [Service.Type=NodePort](https://kubernetes.io/zh/docs/concepts/services-networking/service/#type-nodeport) 或 [Service.Type=LoadBalancer](https://kubernetes.io/zh/docs/concepts/services-networking/service/#loadbalancer) 类型的 Service。

需要云服务商的LoadBalancer，

[Ingress](https://kubernetes.io/zh/docs/concepts/services-networking/ingress/)是一种 API 对象，其中定义了一些规则使得集群中的 服务可以从集群外访问。 [Ingress 控制器](https://kubernetes.io/zh/docs/concepts/services-networking/ingress-controllers/) 负责满足 Ingress 中所设置的规则。

本节为你展示如何配置一个简单的 Ingress，根据 HTTP URI 将服务请求路由到 服务 `web` 或 `web2`。

1. ```shell
   minikube addons enable ingress
   ```

1. ```shell
   kubectl get pods -n ingress-nginx
   ```

1. 使用下面的命令创建一个 Deployment：

   ```shell
   kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
   ```

   输出：

   ```
   deployment.apps/web created
   ```

1. 将 Deployment 暴露出来：

   ```shell
   kubectl expose deployment web --type=NodePort --port=8080
   ```

   ```Bash
   kubectl expose deployment  nginx-deployment  -n default --type=NodePort --port=80
   
   ```

   

   

   输出：

   ```
   service/web exposed
   ```

1. 验证 Service 已经创建，并且可能从节点端口访问：

   ```shell
   kubectl get service web
   ```

   输出类似于：

   ```shell
   NAME      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
   web       NodePort   10.104.133.249   <none>        8080:31637/TCP   12m
   ```

1. 使用节点端口信息访问服务：

   ```shell
   minikube service web --url
   ```

   输出类似于：

   ```shell
   http://172.17.0.15:31637
   ```

##### 创建一个 Ingress

下面是一个定义 Ingress 的配置文件，负责通过 `hello-world.info` 将请求 转发到你的服务。

1. 根据下面的 YAML 创建文件 `example-ingress.yaml`：

   [`service/networking/example-ingress.yaml` ](https://raw.githubusercontent.com/kubernetes/website/main/content/zh/examples/service/networking/example-ingress.yaml)![Copy service/networking/example-ingress.yaml to clipboard](https://d33wubrfki0l68.cloudfront.net/0901162ab78eb4ff2e9e5dc8b17c3824befc91a6/44ccd/images/copycode.svg)

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: example-ingress
     annotations:
       nginx.ingress.kubernetes.io/rewrite-target: /$1
   spec:
     rules:
       - host: hello-world.info
         http:
           paths:
             - path: /
               pathType: Prefix
               backend:
                 service:
                   name: web
                   port:
                     number: 8080
   ```

1. 通过运行下面的命令创建 Ingress 对象：

   ```shell
   kubectl apply -f https://k8s.io/examples/service/networking/example-ingress.yaml
   ```

   输出：

   ```
   ingress.networking.k8s.io/example-ingress created
   ```

1. 验证 IP 地址已被设置：

   ```shell
   kubectl get ingress
   ```

   **说明：** 此操作可能需要几分钟时间。

   接下来你将会在ADDRESS列中看到IPv4地址，例如：

   ```
   NAME              CLASS    HOSTS              ADDRESS        PORTS   AGE
   example-ingress   <none>   hello-world.info   172.17.0.15    80      38s
   ```

1. 在 `/etc/hosts` 文件的末尾添加以下内容（需要管理员访问权限）：

   **说明：** 如果你在本地运行 Minikube 环境，需要使用 `minikube ip` 获得外部 IP 地址。 Ingress 列表中显示的 IP 地址会是内部 IP 地址。

   ```
   172.17.0.15 hello-world.info
   ```

   添加完成后，在浏览器中访问URL `hello-world.info`，请求将被发送到 Minikube。

1. 验证 Ingress 控制器能够转发请求流量：

   ```shell
   curl hello-world.info
   ```

   你应该看到类似输出：

   ```
   Hello, world!
   Version: 1.0.0
   Hostname: web-55b8c6998d-8k564
   ```

   **说明：** 如果你在使用本地 Minikube 环境，你可以从浏览器中访问 hello-world.info。



### 测试成功

![image-20220414105513250](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/aee8b666e29d363697cff7a5598d58bf.png)

账号是admin 

密码是 2jyc2Hvk4Ma6jY54cyy805PH9 来自$PASSWORD

![image-20220414105708026](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/cc5a11ffa228a9d6531a2213a4cfefa9.png)

![image-20220414105724135](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/052fdc3ccef4d7d15721dcfb5b3b2890.png)

cowtransfer 配置代理

传输链接：https://cowtransfer.com/s/1eb5d575199144 或 打开【奶牛快传】cowtransfer.com 使用传输口令：vvhjue 提取；

vcmiao 的邀请链接

https://dddd.xxxxpppp.cyou/auth/register?code=vpMs

##### 直播录屏软件

不能使用windows xbox 录屏，因为会自动关闭。

只能临时下载。


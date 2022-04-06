---
title: "K8S的kubespray安装 1"
date: 2022-03-28T21:36:57+08:00
tags:
  - K8S	
categories:
  - 运维
draft: false 
---

### AMD下架构的单节点安装

https://eminaktas.medium.com/single-node-k8s-cluster-with-kubespray-49588410d9d4

参见了这篇文章。

1.先复制相关ansible的清单。

```shell
# Define a folder name
$ declare -r CLUSTER_FOLDER='my-cluster'
# This for remote installation
cp -rfp inventory/sample inventory/$CLUSTER_FOLDER
# This for local installation
cp -rfp inventory/local inventory/$CLUSTER_FOLDER
```

2.如果没有选择远程安装就不需要这些

```Bash
# Create a list of ip since we are working on a single node we'll just provide single ip
# For local installation, skip this part. We do'nt need to provide a ip address.
# For remote installation provide the ip address
$ declare -a IPS=(<host>)
$ CONFIG_FILE=inventory/$CLUSTER_FOLDER/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

修改host 到  10.174.0.2

```Bash
declare -a IPS=(10.174.0.2)

CONFIG_FILE=inventory/$CLUSTER_FOLDER/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```



修改MetalLB，在 

```bash
inventory/$CLUSTER_FOLDER/group_vars/k8s_cluster/k8s-cluster.yml
```

修改arp_ignore 和arp_announce





#### 如果是root 

可以忽略-b选项。

`ansible-playbook -i inventory/my-cluster/hosts.yaml cluster.yml -v --connection=local`





测试机的IP是 34.97.204.171

创建token

```Bash
以下是完成 kubespray 后运行以访问仪表板的命令。显然，用你的名字替换我的名字（ryan）。除非你的名字也是 ryan，在这种情况下你可以复制/粘贴 :)

# create a new account that can be used to authenticate to the dashboard
kubectl create serviceaccount ryan
# make that new account have the right permissions
kubectl create clusterrolebinding ryan-cadmin --clusterrole=cluster-admin --serviceaccount=default:ryan
kubectl create clusterrolebinding ryan-admin --clusterrole=admin --serviceaccount=default:ryan
# show the token needed to log in to the dashboard.
kubectl -n default describe secret $(kubectl -n default get secret | awk '/^ryan-token-/{print $1}') | awk '$1=="token:"
```

> eyJhbGciOiJSUzI1NiIsImtpZCI6Ii1JX3VZQVh2ejhYTDNBSHZjNDRhRUtZLUR2QVlhR3BoNktBTHlIdFJESE0ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InJ5YW4tdG9rZW4tZzRza2siLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoicnlhbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjRlYTIwMWUxLTM1NzMtNDIzYi1hZDU1LWEzOWVmYzQxZmI2OSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OnJ5YW4ifQ.DFHnuTmuEqiKJDOzWJSZf6_M-VGYXWlgyI9DjAw5qOL4bsuYJVtj-sk7Iv05Ld3bOleCEHEXsjGt1I-68rzqbO3S-tm9lPYJ8jR15qErREUrnV-HKwlGIOXJWBansp-FdEFhk9XTpdZ7Glmpy8yhiR2_umz3dLv7frwNXrylDbyD3fy_Kh7T7KXzWSdG_-NmeqhL364IBWym2YcEDqNi3HIDJ5XuFtPM4JcK83D5DQJrLNXBGiKmEfSZjdfK3rtTDovO-ZW8En5Xg6woftwSGsI0dv7gcEN4ozHb2Wy3Qj0zztovKcCMlETBrVAahat4yq3WC_gPYc_jlcAt9k8WRA

## DNS好像有问题，删除重来~~

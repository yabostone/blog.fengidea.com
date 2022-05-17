---
title: "Salt Cloud下proxmox配置"
date: 2022-05-08T12:13:44+08:00
draft: false

---

### 配置salt-cloud

vim cloud.providers.d/proxmox-6110.conf 

```Yaml
p6110:
  # Proxmox 账户信息
  user: root@pam
  password: xxxx
  url: 192.168.0.200
  port: 8006
  driver: proxmox
  verify_ssl: false
  
```

验证ssl需要设置为false，然后默认是pam信息，如果用域的话就是pve。

p6110是对应的provider

```Bash
 salt-cloud --list-images p6110
```

##### 安装相关包

```Bash
apk add py3-pip
pip install IPy
pip install requests
```



### 不支持proxmox7的最新版



所以不适用。。






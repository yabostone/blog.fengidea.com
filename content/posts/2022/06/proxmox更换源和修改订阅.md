---
title: "Proxmox更换源和修改订阅"
date: 2022-06-11T20:01:45+08:00
draft: false
---

==从jinjun-top网站摘下。https://www.jinjun.top/423.html

社区版本ProxmoxVE 会有一些不怎么友好的操作，弹订阅提示、官方源下载慢、镜像下载慢等，有一次进行配置ceph的时候，没有切换到社区源版本，导致环境崩了，只好重装系统。

## Proxmox VE 6.x/7.x

### 去除官方订阅源

```
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
# 也可以进行删除文件
rm -rf /etc/apt/sources.list.d/pve-enterprise.list
```

## Promox VE 6.x国内加速源

中科大源

```
wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
```

清华大学源

```
wget https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/dists/buster/Release.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-buster.gpg
echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian buster pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
```

更新软件

```
apt update && apt dist-upgrade
```

### LXC仓库源更换

中科大源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.ustc.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.ustc.edu.cn https://mirrors.ustc.edu.cn/proxmox/images/aplinfo-pve-6.dat
systemctl restart pvedaemon
```

清华大学源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.tuna.tsinghua.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.ustc.edu.cn https://mirrors.tuna.tsinghua.edu.cn/proxmox/images/aplinfo-pve-6.dat
systemctl restart pvedaemon
```

南开NJJ源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.nju.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.nju.edu.cn https://mirrors.nju.edu.cn/proxmox/images/aplinfo-pve-6.dat
systemctl restart pvedaemon
```

### CEPH源更换

中科大源

```
echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-pacific buster main" > /etc/apt/sources.list.d/ceph.list
sed -i.bak "s#http://download.proxmox.com/debian#https://mirrors.ustc.edu.cn/proxmox/debian#g" /usr/share/perl5/PVE/CLI/pveceph.pm
```

清华大学源

```
echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/ceph-pacific buster main" > /etc/apt/sources.list.d/ceph.list
sed -i.bak "s#http://download.proxmox.com/debian#https://mirrors.ustc.edu.cn/proxmox/debian#g" /usr/share/perl5/PVE/CLI/pveceph.pm
```

## Promox VE 7.x 国内加速源

南开NJU源

```
wget https://mirrors.nju.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
echo "deb https://mirrors.nju.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
```

清华大学源

```
wget https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/dists/bullseye/Release.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
```

中科大源

```
wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
```

更新软件

```
apt update && apt dist-upgrade
```

### LXC仓库源更换

南开NJU源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.nju.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.nju.edu.cn https://mirrors.nju.edu.cn/proxmox/images/aplinfo-pve-7.dat
systemctl restart pvedaemon
```

清华大学源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.tuna.tsinghua.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.nju.edu.cn https://mirrors.tuna.tsinghua.edu.cn/proxmox/images/aplinfo-pve-7.dat
systemctl restart pvedaemon
```

中科大源

```
sed -i.bak "s#http://download.proxmox.com/images#https://mirrors.ustc.edu.cn/proxmox/images#g" /usr/share/perl5/PVE/APLInfo.pm
wget -O /var/lib/pve-manager/apl-info/mirrors.ustc.edu.cn https://mirrors.ustc.edu.cn/proxmox/images/aplinfo-pve-7.dat
systemctl restart pvedaemon
```

### CEPH源更换

中科大源

```
echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-pacific bullseye main" > /etc/apt/sources.list.d/ceph.list
sed -i.bak "s#http://download.proxmox.com/debian#https://mirrors.ustc.edu.cn/proxmox/debian#g" /usr/share/perl5/PVE/CLI/pveceph.pm
```

清华大学源

```
echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/ceph-pacific bullseye main" > /etc/apt/sources.list.d/ceph.list
sed -i.bak "s#http://download.proxmox.com/debian#https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian#g" /usr/share/perl5/PVE/CLI/pveceph.pm
```

## 去除6.x/7.x 订阅提醒

```
sed -i_orig "s/data.status === 'Active'/true/g" /usr/share/pve-manager/js/pvemanagerlib.js
sed -i_orig "s/if (res === null || res === undefined || \!res || res/if(/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i_orig "s/.data.status.toLowerCase() !== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
systemctl restart pveproxy.service
```

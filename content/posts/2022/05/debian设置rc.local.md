---
title: "Debian设置rc.local"
date: 2022-05-05T09:24:07+08:00
draft: false
---

新的rc.local的服务还是在的，只是关掉了。

debian 11

并且默认情况下这个服务还是关闭的状态：

```bash
root@debian ~ # systemctl status rc-local
● rc-local.service - /etc/rc.local Compatibility
     Loaded: loaded (/lib/systemd/system/rc-local.service; static)
    Drop-In: /usr/lib/systemd/system/rc-local.service.d
             └─debian.conf
     Active: inactive (dead)
       Docs: man:systemd-rc-local-generator(8)
```

为了解决这个问题，我们需要手工添加一个 `/etc/rc.local` 文件：

```bash
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
```

**然后赋予权限：** 注意要授权可执行！！！

```bash
chmod +x /etc/rc.local
```

接着启动 `rc-local` 服务：

```bash
systemctl start rc-local
systemctl enable rc-local
```

再检查下相关服务是否启动

> systemctl status rc-local

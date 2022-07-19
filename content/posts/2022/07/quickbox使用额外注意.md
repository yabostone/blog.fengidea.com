---
title: "Quickbox使用额外注意"
date: 2022-07-15T23:20:28+08:00
draft: false	
---

### samba需要调整，降低安全性

CIFS 默认已经启用加密，且带有基本的账户认证，账户信息同 Dashboard。例如 Windows 环境中，直接在文件管理器的地址栏中输入 `\\[你的服务器IP]` 就可以访问到你的 Samba 共享。NFS 则可在系统功能中勾选安装后以相同方式连接。

##### 注意

NFS 由于其特性，并不直接带有数据加密，不适合在公网环境直接使用，请务必确保一个安全的 LAN 环境，或者在安装 OpenVPN 后，通过 OpenVPN 建立安全连接。通过 OpenVPN 连接时，目标 IP 地址为: `10.8.0.1`。

##### 为什么我的 Android / 群晖 无法连接 CIFS？[#](https://cn.wiki.ptbox.dev/cifs-nfs/#为什么我的-android--群晖-无法连接-cifs？)

由于 CIFS 启用了加密以及数据包签名，因此部分客户端无法连接。

你可以在安装时直接使用 `box install cifs --compatibility`。

##### 注意

这个操作将会明显降低数据传输的安全性，如非 LAN 环境，请尽量避免直接使用。你可以考虑使用 OpenVPN 为这些数据的传输进行加密。

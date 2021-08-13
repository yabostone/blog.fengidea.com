---
title: "512mVPS使用"
date: 2021-08-01T12:10:49+08:00
tags:
  - VPS
  - Shell
categories:
  - VPS
draft: false
---

### 在资源受限下VPS使用

资源受限下，如RAM不足，会导致`kswapd0`命令CPU进程上升，而VPS会对CPU占用时间长的命令自动杀死，导致qbittorrent命令被kill，迫使自动重校验。

安装了aria2，docker，rclone，qbittorrent，rtorrent后RAM资源不足，所以不能安装这么多。



#### 软链接删除错误

在复合使用中使用了软链接，这里在磁盘容量够的情况下优先使用`rsync` 或`cp`命令，次之适合用`ln`命令，删除软链接时，不能加 `\` ,如 `rm -rf \home\soft\` 是删除软链接下的文件夹中的文件，`rm -rf \home\soft` 是删除这个软链接。

关闭自动更新
	
	sudo dpkg-reconfigure -plow unattended-upgrades
	
	modprobe tcp_bbr
	wget -N --no-check-certificate "https://gist.github.com/zeruns/a0ec603f20d1b86de6a774a8ba27588f/raw/4f9957ae23f5efb2bb7c57a198ae2cffebfb1c56/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
	
	bash <(curl -Ls https://git.io/AccTCP)


​	
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
	curl https://rclone.org/install.sh | sudo bash
```

mkdir /home/aria2/
cd /home/aria2/
docker run -d \
--name aria2-pro \
--restart unless-stopped \
--log-opt max-size=1m \
--network host \
-e PUID=$UID \
-e PGID=$GID \
-e RPC_SECRET=rpcrpcsec \
-e RPC_PORT=6800 \
-e SPECIAL_MODE=rclone \
-e LISTEN_PORT=6888 \
-v $PWD/aria2-config:/config \
-v $PWD/aria2-downloads:/downloads \
p3terx/aria2-pro

```
	###添加了rclone后使用docker
```	
docker run -d \
--name rclone01 \
--restart unless-stopped \
--network host \
--volume /home/aria2/aria2-downloads/:/home/aria2/aria2-downloads/ \
rclone/rclone serve webdav --addr 0.0.0.0:18080 --user abcabc --pass abcabc  /home/aria2/aria2-downloads/
```


	```
	nohup  rclone serve webdav --addr 0.0.0.0:18080 --user abcabc --pass abcabc  /home/aria2/aria2-downloads/ &
	```
	
	screen rclone serve webdav --addr 0.0.0.0:8080 /home/mxuan
	screen rclone serve webdav --addr 0.0.0.0:8080 /home/aria2


​	
主机端书写内容（需要手动写出）

	PS C:\Users\mx\Downloads\Documents> for($i=1;$i -lt 60;$i++)
	>> {
	>> rclone sync -P --transfers=3 .\a\ .\b\
	>> sleep 1
	>> }
	Bash for循环
	for i in {1..50}
	do
		rclone sync -P w1: .
		sleep 100
	done


​	

#### 更新推论
可能是因为cpu的峰值限制，rclone serve 被强行关闭了，推荐用5刀的版本（其实差不了多少）。上次的http之前是正常的，考虑到隐私因素，换成webdav还是可以接受的。
不时的中断证明了这点。

还是接着考虑在出错的基础上再次尝试rclone的连接吧。也许就稳定了呢。

`wget "https://github.com/chiakge/Linux-NetSpeed/raw/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh`

```
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```
完成后还有inexistence

```
bash <(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/inexistence.sh)
```

```	
docker run -d \
--name rclone02 \
--restart unless-stopped \
--network host \
--volume /home/mxuan/qbittorrent/download/:/home/mxuan/qbittorrent/download/ \
rclone/rclone serve webdav --addr 0.0.0.0:28080 --user abcabc --pass abcabc  /home/mxuan/qbittorrent/download/
```


/home/mxuan/qbittorrent/download/

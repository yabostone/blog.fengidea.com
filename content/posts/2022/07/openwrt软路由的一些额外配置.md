---
title: "Openwrt软路由的一些额外配置"
date: 2022-07-24T16:39:50+08:00
draft: false	

---

用的Sirpdboy的op，效果很好，稳定性也可以。

这次的主路由用的amd a4-7210的CPU，默认的CPU调度方式schedutil,比较奇怪，第一次见到。CPU限速到了1000Mhz，查看了下还是有调度方式选择的，不用重新编译。

可以手动更改每个cpu的调度，不过还是用rc.local 添加下面的调度为佳。之后就正常了。

```Bash
#shell命令直接查看
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

#shell命令直接改
va=ondemand # performance | powersafe

echo $va > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $va > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo $va > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
...
echo $va > /sys/devices/system/cpu/cpun/cpufreq/scaling_governor
```



在 /etc/rc.local 内部查看

```Bash
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
修改调度器类型。
```



注意pcie接口和USB接口的稳定性，有时候会接触不良，这个需要排查网络中断的位置。好像底下那个USB口不稳定，原因不明，换了一个口，先看看。

好像两台机子都不稳定。。说明还是用intel+pcie的比较稳。



## tailscale和wg

可以在NAT3网络上添加tailscale，然后再用CGNAT网段配上固定的wireguard的endpoint，达到穿透的目的！！


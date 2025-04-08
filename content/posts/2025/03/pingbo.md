---
title: "嵌入式简历信息内容备份"
date: 2025-03-27T09:30:07+08:00
draft: false
tags: ["esp32"]
categories: ["Interview"]
author: ""
description: ""
--- 

多年全栈开发经验中积累硬件交互能力(多协议传感器数据采集,uboot移植,V4L2摄像头驱动)，逆向工程和固件破解能力(IDA Pro/Binwalk逆向分析,设备树重构移植,安全加密破解)，Linux内核监控信息采集和优化能力(内核网络栈优化,系统调用监控,虚拟化调度管理模块开发)。
核心技术栈：
1. 内核mod：a. 协同配合Linux内核网络栈优化(OVS协同dpdk虚拟化改进/eBPF流量监控) b. 开发系统调用拦截模块(实现文件/网络操作实时监控) c. 内核新特性研究(cgroup v2/BPF功能扩展)
2. 系统应用开发：a. 设计和优化cuckoo,基于Qemu-KVM的跨架构虚拟化多系统方案(x86/ARM/macOS)  b. 实现实时性改造(RT-Preempt补丁/调度器优化)
3. 嵌入式专项: a. 嵌入式软件开发全流程经验: 从uboot移植(全志H5),Linux内核裁剪编译(menuconfig定制),到QT界面开发  b. 硬件交互和硬件驱动: 7类传感器统一接入环境，高频数据采集；V4L2相机DMA零拷贝驱动，CMOS传感器参数动态调节  c. 嵌入式安全攻防: 完成QNAP NAS固件全链路破解,实现加密签名绕过和安全限制解除
4. 上位机和物联网:  a. 前端页面Vue2/Steamlit快速开发,后端Django/FastAPI，MQTT和数据库构建云端物联网,TDEngine构建数据采集分析环境。 b. PyQT构建上位机应用框架,Nuitka构建硬件通信组件。 c. 硬件-通信-软件全链路闭环。
4. 开发工具链:   a. 深度使用GDB/Systemtap/BPF Compiler Collection(BCC)   b. 构建自动化恶意样本测试系统   c. 使用Yocto构建专板环境,Qemu虚拟化测试  d. Ansible/Terraform运维   e.Selenium自动化测试和脚本应用	
5. 技术影响力:
	- 技术博客(CSDN排名约2000) https://blog.csdn.net/fengidea ,包含内核机制解析，如： [Linux进程调度EEVDF/CFS算法解析],[eBPF在容器安全监控中的示例应用],[从cubic到bbr的演进(一)]：
- Github中多种语言的开源项目：[Github](https://github.com/yabostone) 
最近更新： [esp远程开机(C++)]设计了MQTT的方案和HTTP的方案
[网络优化脚本(Python/Shell/Ansible)]Streamlit前端界面/FastAPI后端/Ansible的脚本  [ebpf和bpftrace的脚本]
以前更新的： [picgo-plugin-rlcone(TypeScript)](),和插件例如cloudinary
博客涉及范围较广，包括高性能时间序列数据库，go中间件，Python，QT页面，信号处理，数据分析，三高问题，架构设计，传感器数据接入，监控探针，金融数据，CICD，系统安全，沙箱安全，Linux内核分析等等。全栈，go中间件。


外包公司，外派到上海电气算法岗，因为项目审批流程长并甲方领导审批未通过，接着找工作，之前甲方经理口头承诺10月可以走国企转正流程并上报两级领导才入职。

这里将嵌入式开发相关的内容提前：
项目背景：针对QNAP NAS设备操作系统固件安全设置，实现全链路逆向分析和破解系统构建，实现多硬件平台固件移植和重构启动流程，突破厂商安全限制，建立安全研究实验环境。(嵌入式固件破解)
核心技术栈：固件逆向：IDA Pro逆向Bin文件，Binwalk固件提取，Uboot/Tiny Core 启动流程更换（包含Grub2）；硬件抽象层- HAL层逆向，检测加载SATA的设备树(DTS,conf)动态生成，硬件模型绑定技术。安全破解： AES加密解密，pc1静态分析密钥提取，签名绕过(反编译成源代码);系统构建：Busybox，initramfs生成，Grub2引导修复。
关键要点：1.HAL层逆向，通过TTL调式接口分析到调用链，逆向12+关键函数实现逻辑，IDA Pro 逆向重构hal_app替代模块，重新解密模块，实现原有功能。2.动态设备建模，逆向设备树(model_name)生成逻辑，或者来自dmidecode信息，构建dts的model.conf，适配不同的硬件型号。
3.启动链重构，将原有启动方式转为Grub2的Tiny Core Linux的方案，开发initramfs生成器，通过解密后的initramfs等信息集成必要的驱动模块包括不同的网卡驱动模块。
4.测试，移植QNAP的固件替换并在Qemu虚拟化环境测试通过，构架基础破解开发包，并启动QNAP环境。

项目背景：OrangePi-PC2的uboot移植和更新版的Kernel移植（嵌入式Linux开发），基于Allwinner全志的H5芯片，原厂Uboot默认从TF卡启动，并且Linux内核没有更新(适配了GPU)，希望从USB启动或者贴片emmc后启动，来增大系统盘的大小。
目标：完成uboot下全志芯片，orangepi的在PC2的移植，解决开源库的兼容性问题，并且实现TF卡转USB，emmc的启动模式支持。
实现： Uboot下全志尝试编译SPL架构，编译ATF，编译scp，并且打包后写入spi。重新配置Uboot脚本实现介质优先USB，后emmc，回退SD卡。
通过make menuconfig定制配置，关闭冗余功能，精简固件体积。X86下交叉编译ARM架构的Linux内核，重新生成dts，dtb文件，并且启动成功。
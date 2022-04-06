---
title: "Appium控制手机"
date: 2022-04-04T08:29:22+08:00
tags:
  - 开发
categories:
  - 开发
draft: false 
---

### 需要注意的问题

1.需要安装java环境，android sdk。

android sdk 需要是 和adb的版本相匹配，所以需要手动下。

https://www.yeshen.com/faqs/rJTiPhcA-

在输入上述命令之前，我已经将SDK下的adb所在目录（C:\Android-SDK_R24.4.1\platform-tools）、以及夜神模拟器的adb所在目录（C:\Users\leon\AppData\Roaming\Nox\bin）加入了系统的环境变量path中。否则，上述命令将无法执行成功！

1、关掉AS和夜神模拟器。同时去任务管理器里看下，adb.exe以及nox_adb.exe这2个进程有没有在运行？有的话就结束掉。

2、找到SDK的目录和夜神模拟器的目录，将SDK目录下的adb.exe文件，复制到夜神模拟器的目录下，因为夜神模拟器目录下原本的adb文件名字叫做nox_adb.exe，因此复制过去之后也得改名为nox_adb.exe。

3、这样就将AS目录下的adb文件和模拟器目录下的adb文件完全同步了，版本号也一致了。此时，可以使用cmd命令查验一下：



#### 获取包名

二、本地电脑没有apk，但是已经安装到安卓机上

2.1 通过adb命令

a、PC连接Android设备

b、Android设备中点开app，app的任何界面都可以；

c、cmd命令行中输入：adb shell dumpsys window w |findstr \/ |findstr name= 或者 adb shell dumpsys window | findstr mCurrentFocus查看包名

2.2 

a、PC连接Android设备

b、cmd 进入命令行，输入： adb shell pm list package 列出所有的应用的包名 （-s：列出系统应用 -3：列出第三方应用 -f：列出应用包名及对应的apk名及存放位置 -i：列出应用包名及其安装来源）



##### 闲鱼爬虫

https://blog.csdn.net/weixin_43906500/article/details/115623201

[ADB] Connected devices: [{"udid":"389c83e2","state":"device"}]

[AndroidDriver] Using device: 389c83e2

命名需要和 adb devices的名字相同

##### 获取app的activity

获得列表

adb shell pm list package -f



##### 找 activtiy

```
adb shell dumpsys window w | findstr \/ | findstr name=
或者
adb shell dumpsys window |findstr mCurrent
或者
adb shell "dumpsys window w|grep \/|grep name=|sed 's/mSurface=Surface(name=//g'|sed 's/)//g'|sed 's/ //g'"
```

﻿/Users/wangkeren/Library/Android/sdk
adb的Android_HOME
1、查看android版本：
adb shell getprop ro.build.version.release
—
➜  ~ adb devices
List of devices attached
emulator-5554	device
deviceName emulator-5554


！！！ 创建模拟器时一定要下移页面设置磁盘大小！！！
Avd 系统目录
* Mac OS X 和 Linux - ~/Library/Android/sdk/system-images/android-apiLevel/variant/arch/
Example 
/Users/wangkeren/Library/Android/sdk/system-images/android-32/google_apis/arm64-v8a

查看包名
pm list packages ｜ grep

获取应用package和Activity信息命令
adb shell “dumpsys window | grep mCurrentFocus”
包名
com.estrongs.android.pop/com.estrongs.android.pop.view.FileExplorerActivity

需要改成 cold boot ！！！


网络不通：
adb root
adb shell
设置dns
[wlan.driver.status]: ok
emulator64_arm64:/ # setprop net.dns1 114.114.114.114
emulator64_arm64:/ # setprop net.dns2 223.5.5.5

修改dns的方式失败。


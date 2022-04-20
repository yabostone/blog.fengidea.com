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

### python 代码书写

先安装

```Bash
pip install Appium-Python-Client
pip install selenium

```



#### 设置hybrid手机app

###### 自动化混合 Android 应用程序

Appium[通过 Chromedriver 提供内置的混合支持](https://appium.io/docs/en/writing-running-appium/web/chromedriver/index.html)，允许任何 Chrome 支持的 Android 网络视图的自动化。

不幸的是，在您的应用程序构建中还需要一个额外的步骤。如 Android[远程调试文档](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/webviews)`true`中所述，必须在[android.webkit.WebView](http://developer.android.com/reference/android/webkit/WebView.html) 元素上 设置[setWebContentsDebuggingEnabled](http://developer.android.com/reference/android/webkit/WebView.html#setWebContentsDebuggingEnabled(boolean)) 属性。

一旦您设置了[所需的功能](https://appium.io/docs/en/writing-running-appium/caps/index.html) 并启动了 Appium 会话，请按照上面的通用说明进行操作。

https://appium.io/docs/en/writing-running-appium/web/hybrid/index.html



查找元素示例用法

https://appium.io/docs/en/commands/element/find-elements/

###### 定位方式

https://blog.csdn.net/lovedingd/article/details/111058898

###### 1.4 accessibility_id定位

在UI Automator Viewer界面上并没有找到这个字段，这个对应的字段是content-desc，

driver.find_element_by_accessibility_id() 或者 MobileBy.ACCESSIBILITY_ID，代码如下：

![image-20220414142313329](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/b21c5247de6d9330ea5842eaad581858.png)

###### 通过find_by_element_id

https://www.cnblogs.com/dy99/p/14287417.html



###### 通过uiautomator

https://www.cnblogs.com/dy99/p/14287417.html

```
id_text = 'resourceId("com.wm.dmall:id/funcTitle").text("待支付")'
driver.find_element_by_android_uiautomator(id_text).click()
```

elementId。或许看到有个id你又会高兴了。这总该是唯一的了吧！很遗憾，它也是会变化的，所以也不适合用来定位：

elementid会变化，

然后 mobileby的方式只有常见的几种

![image-20220414143835629](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/fedfb67ec99fd26ae21a2024f80c2ffc.png)

https://blog.csdn.net/weixin_44885027/article/details/112917204   这篇讲定位讲的好。





UI Automator 测试类的编写方式应与 JUnit 4 测试类相同。如需详细了解如何创建 JUnit 4 测试类以及如何使用 JUnit 4 断言和注释，请参阅[创建插桩单元测试类](https://developer.android.google.cn/training/testing/unit-testing/instrumented-unit-tests?hl=zh-cn#build)。

在测试类定义的开头添加 `@RunWith(AndroidJUnit4.class)` 注释。您还需要将 AndroidX Test 中提供的 [`AndroidJUnitRunner`](https://developer.android.google.cn/reference/androidx/test/runner/AndroidJUnitRunner?hl=zh-cn) 类指定为默认测试运行程序。[在设备或模拟器上运行 UI Automator 测试](https://developer.android.google.cn/training/testing/ui-testing/uiautomator-testing?hl=zh-cn#run)部分对此步骤进行了更详细的说明。

在 UI Automator 测试类中实现以下编程模型：

#### Hybrid 页面切换

**前言**

小编所在项目的客户端是比较奇怪的一个APP，大部分页面Android和iOS的客户端只提供了webview的功能，都是由H5处理业务逻辑和用户交互。H5承担了和服务端、和客户端的交互。 

虽然在开发实现上很方便，前端开发，三端上线。但是，如果要我们测试要做基于Appium做自动化来说这就不是一件好事儿了，因为Native的客户端可以借助ADB命令和封装的Appium实现大多数点击、跳转、拍照、控制键盘、截图、输入等等操作。一旦切换到H5页面，难题就来了：

 1、H5和native Android的切换？

 2、H5的元素如何定位？

 3、H5中怎么做点击、跳转、控制键盘、输入等？

**Native Android和H5（Android Webview）的切换**

遇到的第一个问题就是，如何从Native Android启动后，去点击/操作H5页面的元素。  搜索了很多之后，有用的资料不多，很多文章写的很复杂，总结一下关键点只有两个。

#### **第一、加载chrome驱动**

在github上找到手机native app中的webview版本，并下载对应的驱动。 

出现了一个新的问题: 怎么找到手机上native app中的webview版本，这里用到的是Chrome的插件ADB plugin(安装方法可用搜索引擎查看)。 

安装完成后在chrome的插件栏就有了Android小机器人的图表，点击小机器人选择’View Inspection Targets’即可打开插件。



可能心细的你可能注意到了，这个控件还有很多其他的属性，例如checked, className, clickable等等，为什么不用这些属性来定位搜索图标呢？答案是，其他控件也有这些值相同的属性、尝试一下你就可以发现很多其他控件的checked属性和搜索控件一样都是`false`，如果我们用`checked(false)`作为条件，将会找到很多控件，而无法确定哪一个是搜索图标。因此，要找到我们想要的那个控件，**选择器的条件通常需要是可唯一确定控件的**。我们通常用一个独一无二的属性来定位一个控件，例如这个例子中就没有其他控件的desc(描述)属性为"搜索"。

另外，对于这个搜索图标而言，id属性也是唯一的，我们也可以用`id("action_search").findOne().click()`来点击这个控件。如果一个控件有id属性，那么这个属性很可能是唯一的，除了以下几种情况：

- QQ的控件的id属性很多都是"name"，也就是在QQ界面难以通过id来定位一个控件
- 列表中的控件，比如QQ联系人列表，微信联系人列表等

尽管id属性很方便，但也不总是最方便的，例如对于微信和网易云音乐，每次更新他的控件id都会变化，导致了相同代码对于不同版本的微信、网易云音乐并不兼容。

除了这些属性外，主要还有以下几种属性：

###### 混合代码

运行报错：An element could not be located on the page using the given search parameters.这个错误很明显是因为没有获取到app上的元素问题导致的，可是对照元素并没有问题，觉得自己对照上了。检查app，发现该app元素是h5和原生代码混合的，所以使用context = driver.getContextHandles();来查询上下文，获取到

WEBVIEW_XXXXX

```Bash
切换webview上下文

AndroidDriver driver = new AndroidDriver(new URL(“http://127.0.0.1:4723/wd/hub”), capabilities);
driver.context(“WEBVIEW_xxxxxxx”); //上下文
driver.findElement(By.xpath("/html/body/div/div[3]/button")).click();
driver.closeApp();
driver.quit();


```

##### 中断需要配置手机

既然知道了是C/S架构，所以每次在调试的时候，记得打印下整体的请求，然后要注意查看S端返回的结果，那我们说下appium执行中断服务端的提示是Could not proxy command to remote server. Original error: Error: socket hang up；主要的原因是新版的appium的ui2server请求过于频繁，耗电量过高被软件或者系统认为是流氓软件直接kill掉。这个问题如果是使用appium1.13.x是不存在这个问题，如果是1.18.x以上就存在这个问题，当然这是我自己使用发现的，尽管1.19版本ui2server 为前端服务也存在这个问题。

**解决方案如下：**

1.appium setting，uiautomator2sever两个服务都给全部权限；

2.在设置的电量管理，把省电管理关掉，以及给ui2两个sever 不受耗电管理，具体你根据机型进行选择；

3.当前面两个都还无法解决的时候，一般是手机管理软件问题，你可以运行脚本，并且在dos下，运行adb logcat -v time > 电脑目录文件，然后当出现的时候，停止脚本，进入adb logcat 日志目录里面根据关键字io.appium.uiautomator2.server 进行查找，然后会找到force ui2ser 是哪个pid kill掉，



##### 需要配置超时时间

配置timeout 7200 秒

###### 抓取微信朋友圈示例

https://python3webspider.cuiqingcai.com/11.5appium-pa-qu-wei-xin-peng-you-quan

###### android home 位置

C:\Users\mx\AppData\Local\Android\Sdk

##### 元素定位，列表 elements

https://www.jianshu.com/p/062916f7080e

```Python
element= driver.find_element_by_id("com.taobao.taobao:id/rv_main_container")
elements = element.find_elements_by_class_name("android.widget.FrameLayout")
elements1 = elements[1].find_elements_by_class_name("android.widget.LinearLayout")
for ele in elements1:
    ele.click()

```

![img](https://upload-images.jianshu.io/upload_images/23850426-ed32d89153703120?imageMogr2/auto-orient/strip|imageView2/2/w/900/format/webp)

![image-20220415112745495](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/f5c593829b22b6a551f22d546dbde5fd.png)

#### find_element

> Please use find_element(by=By.XPATH, value=xpath) instead
>   ac_search_button = driver.find_element_by_xpath('''//android.view.View[@content-desc="搜索"]''')
>
> 

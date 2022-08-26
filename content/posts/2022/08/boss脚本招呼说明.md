---
title: "Boss直聘招呼脚本使用说明"
date: 2022-08-22T14:09:05+08:00
draft: false
---

## 基本说明

脚本搭配抓取的URL链接使用，链接一般去除了公司的重复职位，防止多轮投递。**筛选了HR在一周内活跃的公司的职位**。不然HR那边半年不登录，浪费一天100条招呼语。

## 使用说明

1.先到牛客中找到**我筛选好的链接**，然后保存到文件，使用下面给出的脚本，配置好招呼语(可以提升回复率），配置好selenium环境，断点扫码登陆。修改URL文件位置，开始打招呼。（建议保存的文件内部的URL数量控制到50个），先打完一轮招呼，看看情况。Boss直聘需要对方要求你的简历或者回应了才能投递简历。**根据投递的情况判断简历是否需要修改**。判断招呼用语是否需要修改。

+ 或者自己筛选链接也可以，适用于定地点投递。

2.可以考虑将脚本复制多份，用于第二天再次遍历，修改第二个脚本的招呼语，修改URL文件位置，当天几个小时后进行第二轮招呼，**这样的对方的回应的可能性高些**，建议招呼语中添加，如果不合适请不要回复。

3.更换筛选的URL文件，换个URL保存位置后再次投递。

4.需要对方回复后，手动投递，自己选择简历。

## 配置安装

#### 配置基础环境

1.基础环境Windows加最新版Chrome，下载selenium用的chromedriver，地址 [https://sites.google.com/chromium.org/driver/downloads?authuser=0]( https://sites.google.com/chromium.org/driver/downloads?authuser=0)  如果一直没有升级chrome的话，查询自己的chrome版本，到国内或者官网上下载指定的chromedriver版本，大版本对应chrome的浏览器版本。

2.Windows安装python环境，可以用conda，也可以官网上配置，配置好python环境后用pip(python自带或者手动安装pip包)安装selenium包。（可能需要配置mirrors源，上清华的mirrors就好了。)如果需要更详细的配置说明，参见链接  [https://www.cnblogs.com/qa-freeroad/p/13575520.html](https://www.cnblogs.com/qa-freeroad/p/13575520.html)

```
pip install selenium
## 默认最新环境
```

3.创建指定文件夹，这里是

```
C:\Data\UserData01
```

将下载好的chromedriver文件放在指定位置

```
C:\Data\chromedriver.exe
```

4.使用vscode，在某地创建文件夹，粘贴代码。后面要打断点，不然需要稍微改代码。

5.使用URL配置好。

#### 开始使用吧

1.路径来自这里，相对路径和绝对路径都可以。在代码中修改路径

![image-20220822151718580](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1661152656/2022/08/095fe5d379a6e24d2502c8f754b42c11.webp)

2.time.sleep()打断点处看情况打断点，在这里停下来点击扫码登录。

+ 如果不打断点的话，在提示下方的time.sleep(1) 改成time.sleep(15),然后在15秒内登录。

![image-20220822162833286](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1661156919/2022/08/d185ba3052db006b1459b4e3ce1b751a.webp)

3.这个可能需要操作！！！ 在页面浏览处，如果出现新职位通知的框框，将这个框框右上角x号关掉。

4.支持屏蔽一些公司，通过正则实现，屏蔽词匹配的位置在这里

![](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1661157120/2022/08/f95d4bc0f203a917ac4e4d4b606776fa.webp)

![image-20220822163247183](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1661157169/2022/08/2ba11aec15318cf14b6454c930965d57.webp)

这两个位置配置屏蔽词。filter_company_name 



代码在下方

```
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import time
import re

option = webdriver.ChromeOptions()
option.add_argument(r'''--user-data-dir=C:\Data\UserData02''')
option.add_argument(r'''--disable-gpu''')
option.add_argument(r'''--log-level=3''')

ds = Service(executable_path=r"C:\Data\chromedriver.exe")
driver = webdriver.Chrome(options=option,service=ds)

## 可以相对位置，在vscode的project文件夹下，可以绝对位置，添加C或者D盘的位置
fileLoc = r"shenzhen-java-test"
## ,可以多写一些？？
chat_messages = ["您好，我在进行相关test来投递简历","如果将对话中的你的优势展示，如ACM区域金牌，"]
### chat_message_again
#chat_message_again = ["您好，是岗位没有hc了吗，还是简历不太匹配呢","第二天再次访问页面进行聊天，部分hr会收简历，可能会投递到业务部，但是今年业务部收到的简历很多，所以只能海投碰运气。"]
## 哪些公司不投递，支持正则
## 建议大公司手动投递，
filter_company_name = ["华为","字节","阿里巴巴"]
undo_url = []
s = set()
with open(fileLoc, "r+") as f:
    for x in f.readlines():
        print(x.strip())
        s.add(x.strip().replace("\\\\\\","//"))

driver.get("https://www.zhipin.com/shenzhen/?ka=header-home")
# 在time.sleep(1)此处打上断点。扫码认证登录
## 如果页面不停的跳，手动点一下鼠标到页面上任意区域
time.sleep(1)
time.sleep(1)


for i in s:
    driver.get(i)
    driver.implicitly_wait(15)
    while(True):
        driver.implicitly_wait(8)
        if re.search("security-check.html",driver.current_url):
            print("wait")
            time.sleep(1)
        else:
            break
    try:
        c1 = driver.find_element(By.CSS_SELECTOR,"#main > div.job-box > div > div.job-sider > div.sider-company > div > a:nth-child(2)").text
        c2 = driver.find_element(By.CSS_SELECTOR,"#main > div.job-box > div > div.job-detail > div.detail-content > div:nth-child(5) > div.name").text
        tmp= "None"
        for v in filter_company_name:
            if re.search(v,c1+c2):
              tmp = i
              break
        if tmp !="None":
            undo_url.append(tmp.replace("\n",""))
            break  
    except:
        print("公司信息过滤查询失败")
        undo_url.append(i)
    driver.find_element(By.CSS_SELECTOR,"#main > div.job-banner > div > div > div.info-primary > div.job-op > div.btn-container > a.btn.btn-startchat").click()
    time.sleep(1)
    chat_input_loc=driver.find_element(By.CSS_SELECTOR,"#container > div > div > div:nth-child(2) > div.chat-im.chat-editor > div.chat-input")
    for x in chat_messages:
        chat_input_loc.send_keys(x)
        chat_input_loc.send_keys(Keys.ENTER)
        time.sleep(3)
    print("该岗位已投递，等待几秒再访问")
    time.sleep(18)

print("未投递的URL内容：")
print(undo_url)

```

### 下面是对应的URL链接的页面，根据自己的需求选择 。

+ 注意，哪怕是应届生，也是可以尝试投递1-3年的职位的，HR看到招呼语后可以选择已读不回。部分不是HR，也许会收简历，这样跳过了HR哟。

+ 告诉大家，校招生拿到毕业证的话可以走社招的，只要业务部愿意拿社招的hc给你，现在很多大厂就是这么做的，社招好像和校招不冲突如，多一次机会


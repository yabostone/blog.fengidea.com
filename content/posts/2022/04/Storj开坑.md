---
title: "Storj开坑"
date: 2022-04-05T23:01:21+08:00
draft: false
tags:
  - 存储
categories:
  - 开发
---

### 测试是否可为图床

![image-20220407220637556](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/6db24d734a391c4ce20b2945899ef2e3.png)

可以看出，Storj和B2是最便宜的两家存储商，并且有一定安全等级。

## 读取操作

[由于免费操作和负担得起的带宽](https://www.storj.io/pricing)，读取繁重的应用程序（大量 GET 和 SELECT 请求）可以使用 Storj DCS 节省大量成本。

虽然 Wasabi 有免费的 READ 操作，但他们的合理使用政策对读取繁重的工作负载施加了严重的限制。你可以在这里阅读更多。

其他供应商在读取操作的定价上是相对可比的。

### 合理使用政策

Wasabi 只能提供免费出口，因为它们施加了限制。他们是这样说的：

**如果您每月的出口数据传输量大于您的活动存储量，那么您的存储用例不适合 Wasabi 的免费出口政策**

‍

#### Jest 内容

异步同步内容：https://jestjs.io/zh-Hans/docs/asynchronous

还有另一种形式的 `test` 可以解决这个问题。 使用单个参数调用 `done`，而不是将测试放在一个空参数的函数。 Jest会等`done`回调函数被调用执行结束后，再结束测试。

```js
test('the data is peanut butter', done => {
  function callback(data) {
    try {
      expect(data).toBe('peanut butter');
      done();
    } catch (error) {
      done(error);
    }
  }

  fetchData(callback);
});
```



若 `done()` 函数从未被调用，测试用例会正如你预期的那样执行失败（显示超时错误）。

若 `expect` 执行失败，它会抛出一个错误，后面的 `done()` 不再执行。 若我们想知道测试用例为何失败，我们必须将 `expect` 放入 `try` 中，将 error 传递给 `catch` 中的 `done`函数。 否则，最后控制台将显示一个超时错误失败，不能显示我们在 `expect(data)` 中接收的值。

*注意： `done()` 不应与Promises混合，因为这会导致您测试中的内存泄漏。*

#### 需要先使用uplink授权文件夹

直接使用raw，每个访问图片都会给一个授权，在accesskey中创建新的存储token。

尝试用uplink生成share URL



!!!! 注意 端游里面的密码需要和生成的Passphrase一致（就是多个短语组成的私钥助记词，确保在区块链的私钥一致。

```Bash
uplink.exe share sj://static/Sketchpad.png --readonly=true --url --not-after=none --base-url=https://link.ap1.storjshare.io --auth-service=https://auth.ap1.storjshare.io/
```

生成的文件链接： https://link.ap1.storjshare.io/s/jv7i2fa2debspzspw3thp7dgzvzq/static/

![](https://link.ap1.storjshare.io/raw/jv7i2fa2debspzspw3thp7dgzvzq/static/1920px-OpenWrt_Logo.svg.png)



### 安装go

https://learnku.com/go/wikis/38122



##### 其他存储

###### Polycloud 存储

https://crowdstorage.com/

###### 流量费0.01美元

Polycloud 的定价仅为每月每 GB 0.004 美元。只要您在该月流出的数据不超过 100%，就没有流出或 API 费用。如果您导出的数据量超过了已存储数据量的 100%，那么您只需为任何超额支付每 GB 0.01 美元。*（另请参阅最短存储保留时间常见问题解答）*

###### Tabi存储

 [https://tebi.io/](https://tebi.io/) 



不能用 

![image-20220407185121214](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/4c7bbb717f3dbfa9613a1f0576caf077.png)

需要变更remotePath的方式

![](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/ea6aee36fa8419f59b3679b6a9fe65e3.png)



#### 变更为b2

算来算去，要么是dogecloud国内，存储价格应该算是免费，然后有大概最多几g的流量，考虑不被刷的情况下。

或者是s3+cloudfront，流量免费，存储价格0.12元，

或者是b2+ cloudflare ，流量免费，存储价格0.035元

想想自己就是随便放在基金里面的钱，亏了30%，大概是40块钱，够买云服务几年了。还不如直接用b2，或者s3，没有多少钱的。

storj用满了就开始迁移到s3或者b2。

### 易贝虚拟卡

![image-20220422122439547](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/b3d229ef2ea2f9dff61819377a6efb81.webp)

#### 用来测试网页链接的



   ![等待](https://blog-fengidea-com.onrender.com/picture/2021/07/lADPDh0cQBQ9M-DNaq7NAsQ_708_27310.jpg) 

 ![image-20220422132525511](https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo/picgo/2022/04/728c9ad0d71bf277f47fef7bf35b4dc2.webp)

#### 使用b2+cloudflare

使用免费的cdn需要将域名存放在cloudflare，而自己的站可能要将其转移到国内，所以，相对而言，用amazon的cloudfront似乎更便宜一些。

b2的每天1GB免费也是很香啊，但是这类都有可能会被刷的概率。

如果考虑到会被刷的话，那么还是要用aws，

如果考虑不使用信用卡的话，需要用国内云的国外方式。

但是国内云的价格还是很贵的，参见https://iktao.cn/archives/2020/38.html，每月要多1G的底价。

不然就是用dogecloud了。（国内最香）



### storj 本地的URL

https://link.ap1.storjshare.io/raw/jxl7tkgemjfqomuhhv3epaakfcqq/picgo



### NAT的转发

![image-20220502201604223](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651493776/2022/05/26eb3259f19167b32c9ed24fbcdef80e.webp)

![image-20220502220914279](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1651500556/2022/05/ea562344f8d3004ada677d89c01a49c0.webp)

端口转发可以构建FullCone，但是会需要手动进行端口转发。

端口转发会有端口冲突，需要完全不冲突。


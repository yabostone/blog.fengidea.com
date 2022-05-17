---
title: "Picgo插件开发-dogecloud-配置compress等"
date: 2022-03-30T08:04:56+08:00
tags:
  - 开发	
categories:
  - 开发
draft: false
---

#### typescript配置和安装

需要安装typescript和ts-node

```
npm install -g typescript

npm install -g ts-node
```

#### 配置 ts-node 环境变量

　　1.要想配置环境变量，我们首先要清楚 npm 全局安装 ts-node 的位置

```swift
npm config get prefix
```

　　2.经过上面的语句我们可以知道 npm 全局安装 ts-node 的位置，接下来就是配置为环境变量：

- 桌面“此电脑”右键点击“属性”
- 窗口左侧列表点击“高级系统设置”
- 新窗口点击下方“环境变量”
- “系统变量”选择“Path”，点击“编辑”
- 点击“新建”，将1中得到的路径复制进去，点击保存
- 重启计算机

#### typescript函数的两种方法

```typescript
function fn(x: number, y: string): string {
  return x + y;
}
fn(1, "2");

```

表达式声明

```typescript
const fn = (x: number, y: number): string => {
  return (x + y).toString();
};
```



#### 时间设定

- `atime` "访问时间": 上次访问文件数据的时间。 由 [`mknod(2)`](http://url.nodejs.cn/dC6BPb)、 [`utimes(2)`](http://url.nodejs.cn/58Fxaj) 和 [`read(2)`](http://url.nodejs.cn/3BmXqe) 系统调用更改。
- `mtime` "修改时间": 上次修改文件数据的时间。 由 [`mknod(2)`](http://url.nodejs.cn/dC6BPb)、 [`utimes(2)`](http://url.nodejs.cn/58Fxaj) 和 [`write(2)`](http://url.nodejs.cn/NmUvmK) 系统调用更改。
- `ctime` "更改时间": 上次更改文件状态（修改索引节点数据）的时间。 由 [`chmod(2)`](http://url.nodejs.cn/K3psEw)、 [`chown(2)`](http://url.nodejs.cn/vSBegL)、 [`link(2)`](http://url.nodejs.cn/U8H1mr)、 [`mknod(2)`](http://url.nodejs.cn/dC6BPb)、 [`rename(2)`](http://url.nodejs.cn/YbqghQ)、 [`unlink(2)`](http://url.nodejs.cn/gjRRsM)、 [`utimes(2)`](http://url.nodejs.cn/58Fxaj)、 [`read(2)`](http://url.nodejs.cn/3BmXqe) 和 [`write(2)`](http://url.nodejs.cn/NmUvmK) 系统调用更改。

#### ts到js的build

##### Build

这一步很重要，因为插件默认执行的是`dist/index.js`，这个配置在`package.json`中，如果没Build会安装失败

```
npm run build
# 输出
> picgo-plugin-test@1.0.0 build C:\Users\imba97\Desktop\test
> tsc -p .
Copy
```

之前不知道，一直卡在这一步

##### 测试

需要先在项目文件夹下安装需要的包

```Bash
npm install . --save-dev
// save-dev是在本地安装开发用的依赖，安装devDependencies下的包
npm audit fix --force
```



```bash
npm run build

在对应插件文件夹下安装

rsync -avrP --exclude "node_modules" ".github" .  ~/.picgo/picgo-plugin-dogecloud/
rsync -avrP --exclude "node_modules" ".github" .  ~/.picgo/picgo-plugin-rclone/

// rsync -avrP picgo-plugin-dogecloud/dist  ~/.picgo/picgo-plugin-dogecloud/

# 跳转到picgo文件下 npm install 对应插件。
cd ~/.picgo/

npm install ./picgo-plugin-dogecloud/
//需要在主文件夹下install，这样会更新package.json
//从而添加plugins
npm install ./picgo-plugin-rclone
```

#### nodejs 想返回值数据到外层函数

1.可以使用await

2.可以用promise

3.回调参数callback，在函数内调用callback，然后传入的值即可导出到外层函数。



#### 调整的值

+ 调整了UserConfig

+ 设置了fs的存储token，定时刷新和强制刷新。









#### 测试成功的值

![image-20220330224245933](https://s2.loli.net/2022/03/30/9st28GTpfxdjM6B.jpg)



#### npm publish

为了测试npm包，选择注册后上传一个包。

npm login时需要将

`npm config set registry=https://registry.npmjs.org`

`npm config set registry=https://registry.npmmirror.com`

这样才能上传包。



上传直接

npm publish

会读取相关package ，然后命名上传。



#### await 和 async

await 是异步函数

async是等待一个promise对象。

wait 关键字，await是等待的意思，那么它等待什么呢，它后面跟着什么呢？其实它后面可以放任何表达式，不过我们更多的是放一个返回promise 对象的表达式。注意await 关键字只能放到async 函数里面



##### Promise.all 和await

并行执行的。。

很多人以为await会一直等待之后的表达式执行完之后才会继续执行后面的代码，***实际上await是一个让出线程的标志\***。await后面的函数会先执行一遍，然后就会跳出整个async函数来执行后面js栈（后面会详述）的代码。等本轮事件循环执行完了之后又会跳回到async函数中等待await
后面表达式的返回值，如果返回值为非promise则继续执行async函数后面的代码，否则将返回的promise放入promise队列（Promise的Job Queue）



#### 回调

其`undefined`原因是，`console.log(response)`运行`doCall(urlToCall);`完毕。您还必须传递一个回调函数，该回调函数在您的
*请求* 完成时运行。

首先，您的功能。向其传递回调：

```
function doCall(urlToCall, callback) {
    urllib.request(urlToCall, { wd: 'nodejs' }, function (err, data, response) {                              
        var statusCode = response.statusCode;
        finalData = getResponseJson(statusCode, data.toString());
        return callback(finalData);
    });
}
```

现在：

```
var urlToCall = "http://myUrlToCall";
doCall(urlToCall, function(response){
    // Here you have access to your variable
    console.log(response);
})
```



#### 去除本地提交后强制拉取

```Bash
git reset --hard
git pull
//可以多用两次
```

#### windows 端口被占用的解决方法

- net stop winnat
- net start winnat



#### nrm 选择npm 镜像源

`nrm ls`

`nrm use taobao`

#### 模板字符串 ${} 

要用模板字符串的话不能用单双引号(`"` `'`)，要用反引号(```)。`Tab`键上面那个。
形如：

```javascript
var time = `Time: ${+new Date()}`;
```

#### info ImgInfo

  ``fileName: 'arm.png',`
  `width: 406,`
  `height: 124,`
  extname: '.png'`

#### async 和await 使用注意事项



对于async await的理解和使用总结了一些规则和经验分享给大家：

- async关键字添加到函数中返回的是promise而不是直接返回值
- 在一个async里面可以存在多个await
- 当使用async 和await的时候，先写上try catch用于错误处理，是一个好习惯
- await内循环和迭代器**foreach**时要格外注意，可能会让你出现执行代码的顺序发生改变和错误
- await仅阻止的是async函数中的代码执行。它只能确保promise解析时执行的下一行，如果异步操作已经开始，则await不会对其产生影响
- 使用了await之后我们可以更容易设置断点进行调试debug了
- 对于错误处理方式更友好了，可以与同步代码相同的方式使用try/ catch块

#### picgo-compress的安装方法

这里在线安装总是安装不上，提示要gyp，所以尝试用本地安装的方法



1.将git 直接clone下来。

2.npm install --save 生成相关node_module

3.npm run build  生成js代码

4.GUI本地安装插件

### await

await 和async ，await 必须返回一个promise，才能在此处等待

---
title: "Picgo Rclone插件"
date: 2022-04-06T14:33:10+08:00
draft: false
tags:
  - 存储
categories:
  - 开发
---

#### 使用nodejs的命令进程child_process

需要注意的是，exec 会首先创建一个新的 shell 进程出来，然后执行 command。execFile 则是直接将可执行的 file 创建为新进程执行。所以，execfile 会比 exec 高效一些。exec 比较适合用来执行 shell 命令，然后获取输出（比如：exec('ps aux | grep "node"')），但是 execFile 却没办法这么用，因为它实际上只接受一个可执行的命令，然后执行（没法使用 shell 里面的管道之类的东西）。

exec方式会创建一个新的进程，而execFile默认只是直接执行命令。

#### 文件存储

picgo传递的是一个buffer，需要重新转成文件后才能上传。

```Bash
const handle = async (ctx: IPicGo): Promise<IPicGo> => {
  const smmsConfig = ctx.getConfig<ISmmsConfig>('picBed.smms')
  const imgList = ctx.output
  for (const img of imgList) {
    if (img.fileName && img.buffer) {
      let image = img.buffer
      if (!image && img.base64Image) {
        image = Buffer.from(img.base64Image, 'base64')
      }
      const postConfig = postOptions(img.fileName, image, smmsConfig?.token)
      let body = await ctx.Request.request(postConfig)
```

```Bash
    // 读取图片数据
    var img = imgObject.buffer
    if((!img) && (imgObject.base64Image)){
        img = Buffer.from(imgObject.base64Image, 'base64')
    }

    // 备份图片
    fs.writeFile(`${imagePath}/${imgObject.fileName}`, img, function(err){
        if(err){
            ctx.log.error(`[Autobackup]${err}`)
        }
    })
```

#### Promise 状态

用于表示 promise 的状态

 到执行到 resolve()这个方法的时候，就改变promise的状态为

 fullfiled ，当状态为 fuulfiled的时候就可以执行.then()

 当执行到 reject() 这个方法的时候，就改变 promise 的状态为

 reject，当 promise 为reject 就可以.catch() 这个promise了

 然后这两个方法可以带上参数，用于.then() 或者 .catch() 中使用。

 所以这两个方法不是替代，或者是执行什么，他们的作用就是 用于改变

 promise 的状态。

 然后，因为状态改变了，所以才可以执行相应的 .then() 和 .catch()操作。

||

通过回调里的resolve(data)将这个promise标记为resolverd，然后进行下一步then((data)=>{//do something})，resolve里的参数就是你要传入then的数据



作者：北原夏K
链接：https://www.jianshu.com/p/5b0b89bf4664
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

##### 定义Promise的返回类型

https://www.jianshu.com/p/4f78b2a294cc

使用Promise<mapResult>(){}

mapResult 可以是Interface

##### 需要将域名后面的/去掉

```Bash
https://link.storj.io/s//2022/04/0df4e548da272c565e759cc1c3e56094.png
```

会出现重复

#### 后续改进

将backup 进程放在after uploads？？这会默认注册全部的内容

将上传部分改成异步方式。

#### 调整同步为异步

```js
function execPromise(command) {
    return new Promise(function(resolve, reject) {
        exec(command, (error, stdout, stderr) => {
            if (error) {
                reject(error);
                return;
            }

            resolve(stdout.trim());
        });
    });
}
```

Use the function:

```js
execPromise(command).then(function(result) {
    console.log(result);
}).catch(function(e) {
    console.error(e.message);
});
```

Or with async/await:

```js
try {
    var result = await execPromise(command);
} catch (e) {
    console.error(e.message);
}
```

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



![https://link.ap1.storjshare.io/raw/jwlk3vxbfhmawl2zada3r4rz2sna/static/Sketchpad.png](https://link.ap1.storjshare.io/raw/jwlk3vxbfhmawl2zada3r4rz2sna/static/Sketchpad.png)

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

#### 每个图片都会给一个授权

在accesskey中创建新的存储token




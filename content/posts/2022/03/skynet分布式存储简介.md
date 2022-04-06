---
title: "Skynet分布式存储简介"
date: 2022-03-31T20:27:39+08:00
tags:
  - 开发	
categories:
  - 开发
draft: false
---

###  skynet-js

现在活跃的访问都是在这个包下，需要使用npx webpack来导入js文件。

```
cd your_project
npm install skynet-js
npm install webpack webpack-cli --save-dev
```

Update your `package.json` file.

```
remove - "main": "index.js",
add    - "private": true,
```

Create folders `mkdir dist src`. Make sure you have your javascript files in `src` and the main (entry) javascript is named `index.js`.

Compile with `npx webpack`! You will find the minified `main.js` in the `dist` folder.

### 上传文件等文件操作

```js
const { SkynetClient } = require('@skynetlabs/skynet-nodejs');

const client = new SkynetClient();

// 上传文件
// (async () => {
//     const skylink = await client.uploadFile("../arm.png");
//     console.log(`Upload successful, skylink: ${skylink}`);
// })();
//  sia://AAA2okbNREkKKbp2-PsvRdVK_5_UWtpmD-nbVDW9PQL-6A

const skylink = "AAA2okbNREkKKbp2-PsvRdVK_5_UWtpmD-nbVDW9PQL-6A";
// 下载链接
// (async () => {
//   await client.downloadFile("./dst.jpg", skylink);
//   console.log('Download successful');
// })();
// 生成https链接

(async () => {
  try {
    const url = await client.getSkylinkUrl(skylink);
    console.log(url);
  } catch (error) {
    console.log(error);
  }
})();
```



#### 如何授权和pin

https://docs.skynetlabs.com/developer-guides/server-hosted-skynet-usage#using-your-jwt

# File Persistence

In a browser context, cookies containing encrypted JWTs are used for linking file uploads to your portal account. This is needed for pinning files >90 days or accessing account-only portals.

If your upload method does not support cookies and your file needs to persist longer than 90 days, you will want to upload your file using a Skynet API Key or your encrypted JSON Web Token (located in the `skynet-jwt` cookie.

## Using your Skynet API Key with skynet-nodejs

To use a Skynet API Key, you will specify a `skynetApiKey` when you initialize your client.

```js
const { SkynetClient } = require('@skynetlabs/skynet-nodejs');

const client = new SkynetClient('https://skynetfree.net', {skynetApiKey: SKYNET_API_KEY});
```



//temp 

Currently, no UI exists in the portal dashboard for creating new API keys for your account. If you wish to manually create one, visit your account dashboard page, and run the following in your browser's developer tools console:

```js
fetch("/api/user/apikeys", {method: "POST", headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({public:"false"})}).then((r) => r.json()).then(console.log)
```

#### 上传

```js
// const client = new SkynetClient("https://siasky.net",{
//   "skynetApiKey": skyapikey}
//  );


 const client = new SkynetClient("https://siasky.net", {customCookie: SKYNET_JWT}
 );

// 上传文件
// (async () => {
//     const skylink = await client.uploadFile("../arm.png");
//     console.log(`Upload successful, skylink: ${skylink}`);
// })();
//  sia://AAA2okbNREkKKbp2-PsvRdVK_5_UWtpmD-nbVDW9PQL-6A

const skylink = "AAA2okbNREkKKbp2-PsvRdVK_5_UWtpmD-nbVDW9PQL-6A";
// 下载链接
// (async () => {
//   await client.downloadFile("./dst.jpg", skylink);
//   console.log('Download successful');
// })();
// 生成https链接

// (async () => {
//   try {
//     const url = await client.getSkylinkUrl(skylink);
//     console.log(url);
//   } catch (error) {
//     console.log(error);
//   }
// })();


(async () => {
    const skylink = await client.uploadFile(
    "./dst.jpg",
    
  );
    
    console.log(`Upload successful, skylink: ${skylink}`);
})();
```

测试没有成功，可能需要用npx。


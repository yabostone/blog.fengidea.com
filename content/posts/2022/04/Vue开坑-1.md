---
title: "Vue开坑 1"
date: 2022-04-16T19:41:18+08:00
draft: false
---



### Vue的循环获取信息

![image-20220416194152362](https://s2.loli.net/2022/04/16/ykEHt1zxVL9fBrw.jpg)

#### [组件名大小写](https://cn.vuejs.org/v2/guide/components-registration.html#组件名大小写)

定义组件名的方式有两种：

##### 使用 kebab-case

```
Vue.component('my-component-name', { /* ... */ })
```

当使用 kebab-case (短横线分隔命名) 定义一个组件时，你也必须在引用这个自定义元素时使用 kebab-case，例如 `<my-component-name>`。

##### 使用 PascalCase

```
Vue.component('MyComponentName', { /* ... */ })
```

当使用 PascalCase (首字母大写命名) 定义一个组件时，你在引用这个自定义元素时两种命名法都可以使用。也就是说 `<my-component-name>` 和 `<MyComponentName>` 都是可接受的。注意，尽管如此，直接在 DOM (即非字符串的模板) 中使用时只有 kebab-case 是有效的。

### vue-element-ui

这些框架还是放在后面，先熟悉ui

如果你是一个前端新手，刷过 Vue 官网但是还没做过 SPA 应用（甚至没听说过 SPA 应用），那么这三个框架对你来说还是蛮有挑战的，上手并不容易，我也不是特别建议使用这个来入门。

原因很简单，这三个前端框架都算是比较专业的前端框架，里边集成了很多东西，如果你是新手的话，很容易就搞懵了。

## 开坑-1 

### 配置环境



需要先安装vue，安装vue-cli

再看Picgo修改看看前端书写。

安装 vue3版本的

  `npm install -g @vue/cli`

然后用create 或者init 创建项目。

再使用 `npm run dev`方式 实时预览状态。

`vue -V` 查看版本，`vue serve` 实时预览

npm 设置代理

`npm set proxy=http://127.0.0.1:10809`

`npm set https-proxy=http://127.0.0.1:10809 `



用户体验这个东西真的并不是开发者在开发的时候能够立马就想到的。这点在开发PicGo上我体会很深。

安装开发环境

`npm install --save-dev` 



#### route 索引页

默认是这个

http://localhost:8080/#/test

http://localhost:8080/#/helloworld

如果写成 http://localhost:8080/test#/  默认是首页。


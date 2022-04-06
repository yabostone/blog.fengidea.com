---
title: "Gatsby初使用"
date: 2022-03-28T21:29:55+08:00
tags:
  - gatsby
categories:
  - 运维
draft: false
---

### 初次安装

需要Linux环境下，安装nodejs，和npm。

配置镜像源。

后配置存储的位置，与权限对应，参见下面的内容：

先完成nvm的安装，注意，需要在**非root权限**之下，后面有包必须在非root环境。

##### nvm 安装

```Bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

```

如果网络问题就手动复制粘贴值，默认其他的没有被墙。

把这个复制粘贴一下

```Bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

安装lts版本

```Bash
nvm install --lts
```

切换镜像源

```Bash
npm config set registry https://registry.npmmirror.com

```

配置镜像源

```Bash
wget https://tuna.moe/oh-my-tuna/oh-my-tuna.py
sudo python3 oh-my-tuna.py --global
```

gatsby 依赖的包需要安装gcc（windows需要安装vs2017,6个G）哪有这样子的。

```Bash
apt update -y && apt install gcc build-essential -y
```



下面的实际上是使用root安装的错误，并不能使用，可以忽略。



If you see an `EACCES` error when you try to [install a package globally](https://docs.npmjs.com/downloading-and-installing-packages-globally), you can either:

- Reinstall npm with a node version manager (recommended),

  **or**

- Manually change npm's default directory

## Reinstall npm with a node version manager

This is the best way to avoid permissions issues. To reinstall npm with a node version manager, follow the steps in "[Downloading and installing Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)". You do not need to remove your current version of npm or Node.js before installing a node version manager.

## Manually change npm's default directory

**Note:** This section does not apply to Microsoft Windows.

To minimize the chance of permissions errors, you can configure npm to use a different directory. In this example, you will create and use hidden directory in your home directory.

1. Back up your computer.

2. On the command line, in your home directory, create a directory for global installations:

   

   ```
   mkdir ~/.npm-global
   ```

3. Configure npm to use the new directory path:

   

   ```
   npm config set prefix '~/.npm-global'
   ```

4. In your preferred text editor, open or create a `~/.profile` file and add this line:

   

   ```
   export PATH=~/.npm-global/bin:$PATH
   ```

5. On the command line, update your system variables:

   

   ```
   source ~/.profile
   ```

6. To test your new configuration, install a package globally without using `sudo`:

   

   ```
   npm install -g jshint
   ```

Instead of steps 2-4, you can use the corresponding ENV variable (e.g. if you don't want to modify `~/.profile`):



```
NPM_CONFIG_PREFIX=~/.npm-global
```



### 再配置GATSBY

`gatsby new my-blog-starter https://github.com/gatsbyjs/gatsby-starter-blog`



new的时候总是会出现gyp安装不上的情况。加上模板好像还要自己配置，花了几个小时环境都没搭建成，还是用hugo吧，gatsby到处都是坑。

---
title: "Akash内容"
date: 2022-04-24T18:56:54+08:00
draft: true
---

添加shell的使用



#### shell 链接

https://docs.akash.network/features/v0.14.0#deployment-shell-access

https://docs.akash.network/guides/akash-cli-booster/getting-started-with-the-cli-booster



### 命令行使用

1.先安装命令行

+ 设置代理

  ```Bash
  export http_proxy=http://192.168.10.143:10809
  export https_proxy=http://192.168.10.143:10809
  ```

  

2.设置环境变量

```Bash
AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
AKASH_KEYRING_BACKEND=os
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"
curl -s "$AKASH_NET/api-nodes.txt" | shuf -n 1
AKASH_KEY_NAME=Keplr
akash   --keyring-backend "$AKASH_KEYRING_BACKEND"   keys add "$AKASH_KEY_NAME"   --recover

AKASH_ACCOUNT_ADDRESS=akash1y96lw4xqcxry4vjv6kr80jht3s2frq9f5dp0c0

## rpc节点有有问题的，可能是代理问题，试过只有下面这个非443端口成功

akash query bank balances --node http://akash-sentry01.skynetvalidators.com:26657 akash1y96lw4xqcxry4vjv6kr80jht3s2frq9f5dp0c0
akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS
```

![image-20220424202254517](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650802976/2022/04/020815a228dbbeb9413ef58654ae5021.webp)

https://docs.akash.network/guides/cli/detailed-steps/part-1.-install-akash

cli的详细内容

注意

+ akash_node 可能是代理原因，生成的值为空，需要手动到对应txt文件中复制一个rpc节点使用。需要使用上面的端口
+ 还是需要设定certificate
+ 这里出现了 $AKASH_CHAIN_ID 为空的情况，需要echo 来进行检查
+ akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --gas-prices="0.001uakt" --gas="auto" --gas-adjustment=1.15
+ 最小燃气费为0.001 在创建certificate时候
+ 调整deploy的 价格到100
+ akash tx deployment create deploy.yaml --from $AKASH_KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --gas-prices="0.001uakt" --gas="500000" --gas-adjustment=1.15

```Bash
akash tx cert create client --chain-id $AKASH_CHAIN_ID --keyring-backend $AKASH_KEYRING_BACKEND --from $AKASH_KEY_NAME --node $AKASH_NODE --gas-prices="0.001uakt" --gas="auto" --gas-adjustment=1.15

akash tx deployment create deploy.yaml --from $AKASH_KEY_NAME --node $AKASH_NODE --chain-id $AKASH_CHAIN_ID --gas-prices="0.001uakt" --gas="500000" --gas-adjustment=1.15

AKASH_DSEQ=  来自生成的值，需要寻找
或者直接到gui界面找到一串数字就可以了。



```

![image-20220424215220834](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650808345/2022/04/866f678a1b740bfffcfac464ef62357c.webp)

**创建deployment 0.0005akt**

**接受竞价 0.001akt**



#### 使用shell

```Bash
akash_deployments
选择对应的deployments，然后会自己生成相关环境变量
再用 
akash_shell sh
进入后修改shell的版本

```

![image-20220424225334370](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650812017/2022/04/6566fddfd8e4fdeeea0e6bc4cad42c7a.webp)

这就是水龙头，目前不可用。

#### SDL语言链接

https://docs.akash.network/intro-to-akash/stack-definition-language

#### 关于网络的例子

![image-20220425081043080](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650845446/2022/04/96b3a637f319d6cf2dce58c43e401d67.webp)

![image-20220425081227104](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650845551/2022/04/df1adad91b4f0c39696e88047acd90d5.webp)

as其实对应的是pods容器的端口值，然后再由NodePort进行转发，同时Ingress暂时只负责80和443端口的转发，

由于端口转发的原因，6881的端口被转发到31400开头的端口中，无法进行上传了。

也就是说，所有需要使用固定端口的pods都会有功能缺失，只能用随机端口



#### 感觉很多应用不能用

像nps，frps，以及qb，v2ray等等。



#### 要主动的去求测试token。。


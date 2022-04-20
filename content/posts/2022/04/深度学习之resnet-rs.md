---
title: "深度学习之resnet Rs"
date: 2022-04-19T10:37:55+08:00
draft: false
tags:
  - 深度学习
categories:
  - 开发
---

尝试google的tpu

### resnet-rs

https://cloud.google.com/tpu/docs/tutorials/resnet-rs-2.x?hl=zh-CN

```Bash
gcloud config set project cloud-function-344710
gcloud config set compute/zone     asia-east1-c

//连接tpu，修改机器名称，这里是tpu 虚拟机模式，这里不能用
gcloud alpha compute tpus tpu-vm ssh  resnet-rs-tutorial --zone=asia-east1-c

pip3 install tensorflow-text==2.8.1 --no-deps
### 连接vm
gcloud compute ssh resnet-rs-tutorial --zone=asia-east1-c

### 不能用本地存储

```

#### 尝试vm方式



```Bash
gcloud compute tpus execution-groups create \
 --vm-only \
 --name=resnet-rs-tutorial \
 --zone=asia-east1-c \
 --disk-size=40 \
 --machine-type=n1-standard-8 \
 --tf-version=2.8.0 \
 --preemptible
```

```Bash
gcloud compute tpus execution-groups create \
 --tpu-only \
 --accelerator-type=v2-8  \
 --name=resnet-rs-tutorial \
 --zone=asia-east1-c \
 --tf-version=2.8.0 \
  --preemptible
```
```
export STORAGE_BUCKET=gs://tpubucket6577
export MODEL_DIR=${STORAGE_BUCKET}/resnet-rs-2x
export IMAGENET_DIR=gs://cloud-tpu-test-datasets/fake_imagenet
export PYTHONPATH=/usr/share/models
export TPU_NAME=resnet-rs-tutorial
### 安装必须的包
pip3 install tensorflow-text==2.8.1 --no-deps

```

```Bash
python3 /usr/share/models/official/vision/beta/train.py \
--experiment=resnet_rs_imagenet \
--mode=train_and_eval \
--model_dir=$MODEL_DIR \
--tpu=$TPU_NAME \
--config_file=/usr/share/models/official/vision/beta/configs/experiments/image_classification/imagenet_resnetrs50_i160.yaml \
--params_override="task.train_data.input_path=$IMAGENET_DIR/train*, task.validation_data.input_path=$IMAGENET_DIR/valid*, trainer.train_steps=100"
```

![image-20220419110351305](https://s2.loli.net/2022/04/19/sWSc1f9ojbHQeTZ.jpg)

> ```sh
> 总结：
> 1.代码在vm虚拟机上，而不是在tpu的vm上。
> 2.结果存储必须要在存储桶中，而不能在本地
> 3.export 修改后需要将后面的export 同步修改
> 4.虚拟机元数据增加了。
> 5.重新修改需要改代码，所以要删除gs存储桶的数据。
> 
> ```

![image-20220419111901892](https://s2.loli.net/2022/04/19/JkXzRH25Uu93MV6.jpg)

##### 修改VM的可抢占性。

```Bash
gcloud compute tpus execution-groups create \
 --vm-only \
 --name=resnet-rs-tutorial \
 --zone=asia-east1-c \
 --disk-size=40 \
 --machine-type=n1-standard-16 \
 --tf-version=2.8.0 \
 --preemptible
```

![image-20220419113706674](https://s2.loli.net/2022/04/19/dZzJuxLkv9Giqef.jpg)

好像不能连接，看下情况

> I tensorflow/core/grappler/devices.cc:75] Number of eligible GPUs (core count >= 8, compute capability >= 0.0): 0 (Note: TensorFlow was not compiled with CUDA or ROCm support)

可能是能用`n1-standard-16`的虚拟机

### TPU性能分析

https://cloud.google.com/tpu/docs/cloud-tpu-tools?hl=zh-cn

##### Resnet 成功

![image-20220419130431043](C:\Users\mx\AppData\Roaming\Typora\typora-user-images\image-20220419130431043.png)

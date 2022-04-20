---
title: "深度学习之retinaNet"
date: 2022-04-19T13:31:38+08:00
draft: false
tags:
  - 深度学习
categories:
  - 开发
---

   首先需要添加可抢占式虚拟机用来整理数据，这里需要花费1小时。

#### 前置准备工作

```Bash
gcloud config set project cloud-function-344710
gcloud config set compute/zone     asia-east1-c
## 连接ssh和上面一起
gcloud compute ssh resnet-rs-tutorial --zone=asia-east1-c

gcloud compute tpus execution-groups create \
 --vm-only \
 --name=resnet-rs-tutorial \
 --zone=asia-east1-c \
 --disk-size=3 \
 --machine-type=n1-standard-16 \
 --tf-version=2.8.0 \
 --preemptible
 
 export STORAGE_BUCKET=gs://tpubucket6577
 export DATA_DIR=${STORAGE_BUCKET}/coco
 
 sudo apt-get install -y python3-tk && \
  pip3 install --user Cython matplotlib opencv-python-headless pyyaml Pillow && \
  pip3 install --user "git+https://github.com/cocodataset/cocoapi#egg=pycocotools&subdirectory=PythonAPI"
 
git clone https://github.com/tensorflow/tpu.git

sudo bash tpu/tools/datasets/download_and_preprocess_coco.sh ./data/dir/coco
### 上面的需要3个小时。用16的类型速度更快些
### 然后存储空间需要300G 这个是必须的

Cloud TPU Pod 的默认配额为 0。如需使用 TPU Pod 类型，您必须申请评估配额或额外配额。
```

```Bash
存储桶在美国，所以tpu也是要在美国，下面是测试
gcloud config set project cloud-function-344710
gcloud config set compute/zone     us-central1-a
 
gcloud alpha compute tpus tpu-vm ssh  node-11 --zone=us-central1-a
```

![image-20220419172342827](https://s2.loli.net/2022/04/19/uZ8iLxAR5oFfePn.jpg)

![image-20220419172412081](https://s2.loli.net/2022/04/19/Mxhq47sjAJPbGzm.jpg)

![image-20220419172527454](https://s2.loli.net/2022/04/19/t6ludNMYknfURcQ.jpg)

#### 配置存储桶

```Bash
export STORAGE_BUCKET=gs://cocotpuasia
export DATA_DIR=${STORAGE_BUCKET}/coco

```

#### tpu虚拟机

```Bash
gcloud alpha compute tpus tpu-vm create retinaNet \
--zone=asia-east1-c  \
--accelerator-type=v2-8 \
--version=tpu-vm-tf-2.8.0 \
  --preemptible
  
gcloud alpha compute tpus tpu-vm ssh retinaNet --zone=asia-east1-c

sudo apt update -y
sudo apt-get install -y python3-tk
pip3 install --user Cython matplotlib opencv-python-headless pyyaml Pillow

pip3 install --user 'git+https://github.com/cocodataset/cocoapi#egg=pycocotools&subdirectory=PythonAPI'

# 需要签出2.8.0版本
git clone https://github.com/tensorflow/models.git -b r2.8.0

pip3 install -r models/official/requirements.txt

```

```Bash
export TPU_NAME=local
export STORAGE_BUCKET=gs://cocotpuasia
export DATA_DIR=${STORAGE_BUCKET}/coco
export MODEL_DIR=${STORAGE_BUCKET}/retinanet-train

```

```Bash
python3 main.py \
     --strategy_type=tpu \
     --tpu=${TPU_NAME} \
     --model_dir=${MODEL_DIR} \
     --mode="train" \
     --params_override="{ type: retinanet, train: { total_steps: 10, checkpoint: { path: ${RESNET_CHECKPOINT}, prefix: resnet50/ }, train_file_pattern: ${TRAIN_FILE_PATTERN} }, eval: { val_json_file: ${VAL_JSON_FILE}, eval_file_pattern: ${EVAL_FILE_PATTERN}, eval_samples: 5000 } }"
```

![image-20220419184313721](https://s2.loli.net/2022/04/19/wER9Zjt7LPWcqur.jpg)

#### ShapeMask

```Bash
export STORAGE_BUCKET=gs://cocotpuasia


export RESNET_CHECKPOINT=gs://cloud-tpu-checkpoints/retinanet/resnet50-checkpoint-2018-02-07
export DATA_DIR=${STORAGE_BUCKET}/coco
export TRAIN_FILE_PATTERN=${DATA_DIR}/train-*
export EVAL_FILE_PATTERN=${DATA_DIR}/val-*
export VAL_JSON_FILE=${DATA_DIR}/instances_val2017.json
export SHAPE_PRIOR_PATH=gs://cloud-tpu-checkpoints/shapemask/kmeans_class_priors_91x20x32x32.npy
export MODEL_DIR=${STORAGE_BUCKET}/shapemask


```

![image-20220419185721118](https://s2.loli.net/2022/04/19/Xg51oeTPfJUSMGk.jpg)

```Bash
python3 main.py \
  --strategy_type=tpu \
  --tpu=${TPU_NAME} \
  --model_dir=${MODEL_DIR} \
  --mode=train \
  --model=shapemask \
  --params_override="{train: {total_steps: 100, learning_rate: {init_learning_rate: 0.08, learning_rate_levels: [0.008, 0.0008], learning_rate_steps: [15000, 20000], }, checkpoint: { path: ${RESNET_CHECKPOINT},prefix: resnet50}, train_file_pattern: ${TRAIN_FILE_PATTERN}}, shapemask_head: {use_category_for_mask: true, shape_prior_path: ${SHAPE_PRIOR_PATH}}, shapemask_parser: {output_size: [640, 640]}}"
  
  
### 600步
python3 main.py \
  --strategy_type=tpu \
  --tpu=${TPU_NAME} \
  --model_dir=${MODEL_DIR} \
  --mode=train \
  --model=shapemask \
  --params_override="{train: {total_steps: 600, learning_rate: {init_learning_rate: 0.08, learning_rate_levels: [0.008, 0.0008], learning_rate_steps: [15000, 20000], }, checkpoint: { path: ${RESNET_CHECKPOINT},prefix: resnet50}, train_file_pattern: ${TRAIN_FILE_PATTERN}}, shapemask_head: {use_category_for_mask: true, shape_prior_path: ${SHAPE_PRIOR_PATH}}, shapemask_parser: {output_size: [640, 640]}}"
```

![image-20220419191917583](https://s2.loli.net/2022/04/19/aHAz54XYsndCc7m.jpg)

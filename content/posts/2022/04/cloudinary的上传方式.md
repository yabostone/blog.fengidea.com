---
title: "Cloudinary的上传方式"
date: 2022-04-24T15:24:46+08:00
draft: false

---

又在写一个新的插件，

### 上传用base64

https://cloudinary.com/documentation/upload_images#file_source_options

https://cloudinary.com/documentation/upload_images

base64上传

https://cloudinary.com/documentation/upload_images#upload_via_a_base_64_data_uri

option的字段来自api，参见

https://cloudinary.com/documentation/image_upload_api_reference

### 测试用的命令

```Bash
rsync -avrP --exclude "node_modules" ".github" .  ~/.picgo/picgo-plugin-cloudinary/
```

#### 一些注意的地方

base64，需要拼接，然后extName获取图片格式。再拼接，

文件名只用md5，不添加extName到public id处

![](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1650792496/2022/04/4eb6a9bd84c0b28a1e461aa74b561247.webp)


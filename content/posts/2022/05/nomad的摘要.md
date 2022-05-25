---
title: "Nomad的摘要"
date: 2022-05-21T19:32:34+08:00
draft: false
---

nomad 跑定时任务的例子https://github.com/hashicorp/cronexpr#implementation   cron的定义



**注意可以有7个值，最少5个值，六个值时没有秒。**

支持每秒的格式@@@ config 下面没有等号，是HCL2

```Bash
目前小组主要使用nomad来跑定时task，比如每5分钟、每30分钟执行的任务等等
下面的是每10s执行一次，一共7个值

job "after" {

    datacenters = ["dc1"]

    type = "batch"

    periodic {
        cron             = "*/10 * * * * * *"
        prohibit_overlap = true
    }

    group "test" {
        count = 1

        task "two" {
            driver = "raw_exec"

            config {
                command = "/data/nomad/two.sh"
            }
        }
    }
}
```

![image-20220521194302178](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653133384/2022/05/c70d5e9bed3d7514035881f5d3cb0d68.webp)

#### 配置思路

先在好机子里面开发，开发完成后打包重新部署。

#### 资源限制

https://www.nomadproject.io/docs/job-specification/resources

```Bash
job "docs" {
  group "example" {
    task "server" {
      resources {
        cpu    = 100
        memory = 256

        device "nvidia/gpu" {
          count = 2
        }
      }
    }
  }
}
```

![image-20220521225423395](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1653144865/2022/05/7da5f5491c217b7656d571fa41179131.webp)

数据默认存在这个文件夹下面。

https://gist.github.com/angrycub/ee9dd4099f1117100dd29608f2028aa8

nomad 似乎有垃圾收集。https://stackoverflow.com/questions/46356788/remove-older-allocations-details-of-a-job-in-nomad

```Bash
nomad system gc 

清除old的没有活动的数据，可能需要隔段时间写脚本关闭job，然后再重新开job。。。
以及设定3分钟一次的ip判断。
```

考虑每次调用都是要生成日志的，所以用service，内部循环也许方便些。同时，可以直接用内部的list作为列表了。。。省去了数据库

python 有 sheduler库。

```Bash
import schedule
import time

def job():
    print("I'm working...")

schedule.every(10).minutes.do(job)
schedule.every().hour.do(job)
schedule.every().day.at("10:30").do(job)

while 1:
    schedule.run_pending()
    time.sleep(1)
```




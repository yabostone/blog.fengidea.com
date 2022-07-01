---
title: "Ankisyncd自建服务器反代和注意事项"
date: 2022-06-20T10:27:03+08:00
draft: false

---

### 注意事项

![image-20220620102719799](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655692052/2022/06/cb6f6a037825d7396aeb952057853897.webp)

Windows下面还是用http，https需要手动添加ssl的证书，哪怕disable也是很麻烦。

#### 反代问题

需要用log查看反代是否到位，测试后发现，如果用子目录的形式，需要添加重定向，防止，直接返回调用子目录。

目前使用反代是全局反代，二级目录的方式预计需要设置相关重定向，没怎么搞，**不要设置子目录**宝塔砂锅面。

```Bash
#PROXY-START/

location ^~ /
{
    proxy_pass http://192.168.0.19:27701/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header REMOTE-HOST $remote_addr;

    add_header X-Cache $upstream_cache_status;
    #Set Nginx Cache
    set $static_filemdyyS4mQ 0;
    if ( $uri ~* "\.(gif|png|jpg|css|js|woff|woff2)$" )
    {
        set $static_filemdyyS4mQ 1;
        expires 12h;
        }
    if ( $static_filemdyyS4mQ = 0 )
    {
    add_header Cache-Control no-cache;
    }
}

#PROXY-END/
```

更新，上述的图片上传有问题，需要找到对应问题在哪里。可能是写的同步服务有问题，这次用的创建新账号和重新导入导出的方式解决了。





#### 设置对anki的反代

https://logi.im/script/reserve-proxy-ankiweb-via-nginx.html



![image-20220622100259822](https://res.cloudinary.com/dbzr1zvpf/image/upload/v1655863384/2022/06/c180353f48e338f7c12a1343972f94be.webp)

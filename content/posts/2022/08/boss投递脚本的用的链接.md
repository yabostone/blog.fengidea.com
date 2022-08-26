---
title: "Boss投递脚本的用的链接"
date: 2022-08-22T17:09:16+08:00
draft: false
---

## 注意事项

1.URL的//转为了\\\\\，有需要手动查看的小伙伴用最下方的代码重新转回。

2.URL的职位对应的HR都是一周内活跃，三日或者刚刚活跃，但是仍然可能没有对应职位放出。

3.工作年限不是限制，应届也可投1-3年的，只要招呼打的好，就有机会。

4.可以第二天再次使用脚本，注意语气诚恳。

5.务必将一些大厂的名称屏蔽，例如华为，华为od请自己单独选择岗位投递，HR很热情，而且要身份证号的。

6.去掉了猎头和人力资源代理的，这样更适配工作年限低的要求。

### 脚本转换代码

```
#!/bin/env python
loc = r"basebase\zhipin-qiuji\txt\shenzhen-java102102"
dest = loc + "-ori"
s=[]
with open(loc,"r+") as f:
    s = f.readlines()
for ind ,value in enumerate(s):
    s[ind] = value.replace("\\\\\\","//").replace("\n","")
print(s)
with open(dest,"w+") as ff:
    for v in s:
        ff.writelines(v)
        ff.writelines("\n")

### 重新写入到新文件以-ori结尾

```



### URL基本情况

这部分来自**深圳市**的抓取的工作年限为**应届生**的，岗位为JAVA。

```
https:\\\www.zhipin.com/job_detail/418cbfd00a682f221XZ73t67FVFX.html
https:\\\www.zhipin.com/job_detail/ee1aeaa3c99baed51n1509-8ElJQ.html
https:\\\www.zhipin.com/job_detail/acd5bf0c3fe144351Xdz2928ElZR.html
https:\\\www.zhipin.com/job_detail/5f3a609d708b9ee61Xd52968EFJS.html
https:\\\www.zhipin.com/job_detail/01a6b724006c78ea1XB72tu_EVVY.html
https:\\\www.zhipin.com/job_detail/9a54786bff357f6c1Xdz2d-7GFJX.html
https:\\\www.zhipin.com/job_detail/0ed0b723e68d09401XB42d69FVtT.html
https:\\\www.zhipin.com/job_detail/4f1d5e1efdfd8e6b1n180t29GVNU.html
https:\\\www.zhipin.com/job_detail/e026f16fd476b8041nZ-29S5EFdU.html
https:\\\www.zhipin.com/job_detail/8e0c29661e3012c51Xd829W4E1VU.html
https:\\\www.zhipin.com/job_detail/11393488c9f4e1481XB60t-4FFRR.html
https:\\\www.zhipin.com/job_detail/687121126bd305851XV729u5EVBV.html
https:\\\www.zhipin.com/job_detail/6ecd6a7c9ec18cd71nN63di8FFFV.html
https:\\\www.zhipin.com/job_detail/9aab30e7a8c893ba1Xd909-1EVVQ.html
https:\\\www.zhipin.com/job_detail/ef230deb30a7f9c81nZ62dm1GVJQ.html
https:\\\www.zhipin.com/job_detail/c3d6f4d727558c2a1Xdz2Nu-FlNU.html
https:\\\www.zhipin.com/job_detail/425e5989001973501XB42t-_FFNY.html
https:\\\www.zhipin.com/job_detail/91a738345b84be0e1n1639i9F1tS.html
https:\\\www.zhipin.com/job_detail/0a1e8d791b1c6cc51XB709y8FlJZ.html
https:\\\www.zhipin.com/job_detail/615f323f43e82f8f1XV609m6FVdV.html
https:\\\www.zhipin.com/job_detail/222b795c103c09e71Xd63t20FldX.html
https:\\\www.zhipin.com/job_detail/76f633330d8321301Xdz396-ElVY.html
https:\\\www.zhipin.com/job_detail/b6b7f63d0f004f641Xd509W6FlJS.html
https:\\\www.zhipin.com/job_detail/1c12af40d09b46d11XB72tu5FlFW.html
https:\\\www.zhipin.com/job_detail/cb427ad1ac25320e1Xd53dW_FldY.html
https:\\\www.zhipin.com/job_detail/67265c381389249b1n143du7ElZT.html
https:\\\www.zhipin.com/job_detail/f70df5c299abcd981nZ82dq4GVdS.html
https:\\\www.zhipin.com/job_detail/ae6a20a4310e56b21XZ62t-5ElFZ.html
https:\\\www.zhipin.com/job_detail/59197c4c6ebceb8b1Xd_3du8EVtV.html
https:\\\www.zhipin.com/job_detail/19eeccbfab2f3ee31Xdy3Nq7E1tV.html
https:\\\www.zhipin.com/job_detail/bbcf65380bae1ec81XZz0tq6GFNY.html
https:\\\www.zhipin.com/job_detail/1fca9dcdd327cce41Xd63d2-F1FV.html
https:\\\www.zhipin.com/job_detail/82c8d12537faafd81Xd52N26EFFX.html
https:\\\www.zhipin.com/job_detail/c8c0b2bb712f1f981XB42d69EFFX.html
https:\\\www.zhipin.com/job_detail/854ae706a04a18fd1Xd43dq7GVFR.html
https:\\\www.zhipin.com/job_detail/36fe4951ab905dd11Xd-0ti4E1JY.html
https:\\\www.zhipin.com/job_detail/e8594576cf0ec40a1XV52d2-EFFT.html
https:\\\www.zhipin.com/job_detail/9de812a751f7b8901Xd53N-0GFVX.html
https:\\\www.zhipin.com/job_detail/d27b9ffc2cb5a89e1Xd73Nm8FlRS.html
https:\\\www.zhipin.com/job_detail/3b84f2197ad0f9f31Xd63dS4GVBR.html
https:\\\www.zhipin.com/job_detail/4636e7fb34fa3dda1Xd93t60E1NR.html
https:\\\www.zhipin.com/job_detail/92fcb0aaec51b16a1nZ72dS0FVpS.html
https:\\\www.zhipin.com/job_detail/1b471dcdb66dc6711Xdy3Nu7FVZS.html
https:\\\www.zhipin.com/job_detail/f25001a4365adf221Xd-2Nq1FFdR.html
https:\\\www.zhipin.com/job_detail/a0a79b56f99d0b511nV-29W8FFpY.html
https:\\\www.zhipin.com/job_detail/e00cabccb5f7b1011XZ42dq-FlNT.html
https:\\\www.zhipin.com/job_detail/82c2e6b97861a7161Xdy09-0GVdR.html
https:\\\www.zhipin.com/job_detail/e88ff8bebd25f1821Xd83t69EVdW.html
https:\\\www.zhipin.com/job_detail/fe8b47718cc403681XB42N2_EldR.html
https:\\\www.zhipin.com/job_detail/65efabf2563bd7a71Xd-0965FVNS.html
https:\\\www.zhipin.com/job_detail/4ace3ab6ef5173d103R92NS4FlE~.html
https:\\\www.zhipin.com/job_detail/c29106170c9b10061Xdy0t-1E1NZ.html
https:\\\www.zhipin.com/job_detail/dbb60aabc6a41b0f1XRz09-_FlBR.html
https:\\\www.zhipin.com/job_detail/408d019ed29f8a141XB62ty4ElZU.html
https:\\\www.zhipin.com/job_detail/db8e597fc00fe1271XB73dq6FldQ.html
https:\\\www.zhipin.com/job_detail/1dc3a206b32b597f1XZ729-8EFpS.html
https:\\\www.zhipin.com/job_detail/138a73afe1a84da21Xd809-5EFpU.html
https:\\\www.zhipin.com/job_detail/a76263b6be5e91561H1_3tW7FVs~.html
https:\\\www.zhipin.com/job_detail/dfe05ced02f437991nZ62dm0GFZW.html
https:\\\www.zhipin.com/job_detail/73086f9a0d30759b1Xdz39W-F1RY.html
https:\\\www.zhipin.com/job_detail/3aa2246f31a9345b1Xd_2tu9GFVV.html
https:\\\www.zhipin.com/job_detail/1c533e5e6b79544a1Xd_39q8EVZZ.html
https:\\\www.zhipin.com/job_detail/a602925f7000acec1XB62ty1ElFY.html
https:\\\www.zhipin.com/job_detail/26b928b3caaa74bf1Xd92928FlpX.html
https:\\\www.zhipin.com/job_detail/dc1c06647e0a69341nZ80968FVRU.html
https:\\\www.zhipin.com/job_detail/ccae2b8b9a594cd31XR729m4F1NR.html
https:\\\www.zhipin.com/job_detail/7d8ba95c0c3b82811nZ429W4FldV.html
https:\\\www.zhipin.com/job_detail/fcfded6d513531e91XV62Nq6GFVU.html
https:\\\www.zhipin.com/job_detail/7a1d37552ef359c81Xd-0965GFVR.html
https:\\\www.zhipin.com/job_detail/eca0416de42114bf1XB60t6-GFtX.html
https:\\\www.zhipin.com/job_detail/0460cc6aa6432f7a1XB42ty9FlZV.html
https:\\\www.zhipin.com/job_detail/8c7972ed75ff29091nxy2Ny1GVRZ.html
https:\\\www.zhipin.com/job_detail/1b5a3722f7f016ec1XB70t2-FlVR.html
https:\\\www.zhipin.com/job_detail/293ff5ae309987f91Xd_39u-FVBT.html
https:\\\www.zhipin.com/job_detail/68a9cbdf41d3d13b1nJz09y6GVM~.html
https:\\\www.zhipin.com/job_detail/0ab5b3a6b62f22f51Xd63dS7FlFY.html
https:\\\www.zhipin.com/job_detail/c41649ed3b82cd9a1XZ_396-F1dY.html
https:\\\www.zhipin.com/job_detail/5d066f35497819521XB629u0F1VW.html
https:\\\www.zhipin.com/job_detail/bd8982da59d860b11Xdz39S4F1dV.html
https:\\\www.zhipin.com/job_detail/ca4d5e040e1a4dc81Xd_39q-FlNW.html
https:\\\www.zhipin.com/job_detail/ef3d214be60260b61XRz3N68GFtU.html
https:\\\www.zhipin.com/job_detail/f472931b3410ca701nZ909S0EFJU.html
https:\\\www.zhipin.com/job_detail/6dbd238545dd2a681Xd63dS7GFZW.html
https:\\\www.zhipin.com/job_detail/9b11683a23594f171XV609i_FlBW.html
https:\\\www.zhipin.com/job_detail/55dcede0c790e64d1Xdz2NS8EFdX.html
https:\\\www.zhipin.com/job_detail/86efe20eec56928c1Xd_39q-E1JZ.html
https:\\\www.zhipin.com/job_detail/6ec44f748ea864a91XB73dm8FFpX.html
https:\\\www.zhipin.com/job_detail/953099e7ac43f17c1nN_09y1EVpZ.html
https:\\\www.zhipin.com/job_detail/6d9de9d8248546511Xdy29-4E1BV.html
https:\\\www.zhipin.com/job_detail/0829a9ff358cadd91nxy3Ni1FFVZ.html
https:\\\www.zhipin.com/job_detail/0096f1ab01d7db8c1Xd43dq7EVpV.html
https:\\\www.zhipin.com/job_detail/e7a63276fae20d6c1XZ_3t65ElVV.html
https:\\\www.zhipin.com/job_detail/c80482be6c2be90e1XR50t24F1BV.html
https:\\\www.zhipin.com/job_detail/a0acd0fbdb5ed42f1XB60ty0GFFY.html
https:\\\www.zhipin.com/job_detail/298bb135c025ebff1XR63dS8ElBZ.html
https:\\\www.zhipin.com/job_detail/66dce9727d0b12671XV52tS-FltS.html
https:\\\www.zhipin.com/job_detail/fea880ab49fb53301Xdz2d--GFpU.html
https:\\\www.zhipin.com/job_detail/e3fe7af4b9f38bc11XV609i7GVdW.html
https:\\\www.zhipin.com/job_detail/4da29c87ecd21aee1n193ty5GFFV.html
https:\\\www.zhipin.com/job_detail/9ff4c48f2b4d03d81Xd_39W0F1ZV.html
https:\\\www.zhipin.com/job_detail/ed15d16ece9a39fc1XZy3Ni_FVdR.html
https:\\\www.zhipin.com/job_detail/3026b83ffbcabb311Xd829W4EVtX.html
https:\\\www.zhipin.com/job_detail/813897c72d1f9f3b1n1_3t2_FlRX.html
https:\\\www.zhipin.com/job_detail/c342ac4c512cc7581nZ809m9GVFU.html
https:\\\www.zhipin.com/job_detail/72b7bfcca91d3c1d1XZy3t-9FFpS.html
https:\\\www.zhipin.com/job_detail/784dadf3c820fab31Xd_3968EVNQ.html
https:\\\www.zhipin.com/job_detail/ab848e0f18bc7b7a1nx93dq1FltT.html
https:\\\www.zhipin.com/job_detail/acaeaba95ebc99731XB609u9GVJX.html
https:\\\www.zhipin.com/job_detail/a5862568965d1c801n1z2ti0F1FY.html
https:\\\www.zhipin.com/job_detail/4283e57061cedb961XB729y1EVpV.html
https:\\\www.zhipin.com/job_detail/4905a3ba25fa56b71Xd-0tW1EVRQ.html
https:\\\www.zhipin.com/job_detail/422407d55fcff25f1XB73d-0FVtW.html
https:\\\www.zhipin.com/job_detail/e26651f244b57a991Xd62tm-ElpU.html
https:\\\www.zhipin.com/job_detail/aec684c815550c801Xd529S8F1pR.html
https:\\\www.zhipin.com/job_detail/2b3956ecf74340651Xdz2tu_GVVR.html
https:\\\www.zhipin.com/job_detail/5692359338cf33421XB73dy8FltY.html
https:\\\www.zhipin.com/job_detail/d72154d5b1a78c1d1Xdz29i5FldQ.html
https:\\\www.zhipin.com/job_detail/fc5e23a605b497e71Xdy3tS0EVFZ.html
https:\\\www.zhipin.com/job_detail/2a6f1c01235712a71nx40961GVRQ.html
https:\\\www.zhipin.com/job_detail/dfedba1d984b63ed1Xd-0tq0F1BY.html
https:\\\www.zhipin.com/job_detail/dc5db326efc735cd1nx_2di9FVZQ.html
https:\\\www.zhipin.com/job_detail/a58261a57adbd9ba1XB609q4GVRX.html
https:\\\www.zhipin.com/job_detail/f1ec069f6e87f78e1nJ50t-7FFZV.html
https:\\\www.zhipin.com/job_detail/177994169465547d1nx_2t2-F1RS.html
https:\\\www.zhipin.com/job_detail/5b947adfb2ac33e41Xd-39q1GFpV.html
https:\\\www.zhipin.com/job_detail/bc3f3717efeaaadc1XB63N-_F1VQ.html
https:\\\www.zhipin.com/job_detail/5164744e379534201Xd509q4EVJR.html
https:\\\www.zhipin.com/job_detail/9c73e8d5b73dbee51n1929q5F1FX.html
https:\\\www.zhipin.com/job_detail/1219b635031e05001XB63Nm4GFJS.html
https:\\\www.zhipin.com/job_detail/356fc42358b92db21Xd609q4F1BY.html
https:\\\www.zhipin.com/job_detail/b2c23411eb59649f1Xd539u0GFtZ.html
https:\\\www.zhipin.com/job_detail/dfe7d592f3000d2f1XR83tq0ElVW.html
https:\\\www.zhipin.com/job_detail/06fa6de0cac23ef81XB42d28GFtQ.html
https:\\\www.zhipin.com/job_detail/a7678952c4194cf51nF90t66E1JY.html
https:\\\www.zhipin.com/job_detail/921383bf08cdc2551XZ40tm5GVVW.html
https:\\\www.zhipin.com/job_detail/4dc75f8327568e171XZz096_GFJQ.html
https:\\\www.zhipin.com/job_detail/3247e1e4f449b56e1Xdy2ty5GFFR.html
https:\\\www.zhipin.com/job_detail/dba6b6f91ce5a0091XB73t61GFNZ.html
https:\\\www.zhipin.com/job_detail/c8215bd1c8c3b3f61Xdy3tS9FlVT.html
https:\\\www.zhipin.com/job_detail/b886d38264ef04271Xdz3ty5F1NR.html
https:\\\www.zhipin.com/job_detail/b0e20e93e35e89fe1Xd73tq1GFpV.html
https:\\\www.zhipin.com/job_detail/3f72a7b9fe24eec01XB62tS4FVtX.html
https:\\\www.zhipin.com/job_detail/467cc666a04246791XB729-9E1pS.html
https:\\\www.zhipin.com/job_detail/884b8f6671e197b51nJ_2ty6FVM~.html
https:\\\www.zhipin.com/job_detail/47aa99b0d466ebcb1XB729m5EFZQ.html
https:\\\www.zhipin.com/job_detail/ac20cd7ec30837c51XR43tS_EFVU.html
https:\\\www.zhipin.com/job_detail/2910ad5ad9c1b1321nx909i8F1pS.html
https:\\\www.zhipin.com/job_detail/007e6c0678c8bcac1XV93di-FVtV.html
https:\\\www.zhipin.com/job_detail/b960ec30907311bd1Xd_39W_FFdZ.html
https:\\\www.zhipin.com/job_detail/e7189199bb1746ba1XB63N67GFdY.html
https:\\\www.zhipin.com/job_detail/fa581a42e8a07b0e1XB42ti4GVZR.html
https:\\\www.zhipin.com/job_detail/c5362e086217b7101XVz29q5EVJR.html
https:\\\www.zhipin.com/job_detail/b434ae47d5f956d41Xdz2d66EVZY.html
https:\\\www.zhipin.com/job_detail/0a260bb1e84fb7e01Xd_396-E1dQ.html
https:\\\www.zhipin.com/job_detail/7c22aebb667c80211Xdz2t21EFVZ.html
https:\\\www.zhipin.com/job_detail/5f97b1b47b9a298c1Xd-29i7FlFX.html
https:\\\www.zhipin.com/job_detail/f566c86c8f4e48110XNz3ti1EA~~.html
https:\\\www.zhipin.com/job_detail/428a248bed8f84c81Xd739m0E1VQ.html
https:\\\www.zhipin.com/job_detail/6f7f3361cee098e21XB72dm0GVNR.html
```



### URL基本情况

这部分来自**深圳市**的抓取的工作年限为**在校生**的，岗位为JAVA。在校生是干甚的？？可能是实习？？不懂，投就是。

```
https://www.zhipin.com/job_detail/01428ad649c928591nZ639m7E1FR.html
https://www.zhipin.com/job_detail/c57f716bf8cea72c1nZ839q_ElJS.html
https://www.zhipin.com/job_detail/8b0fdd36c03a90ee1XZ609y8EVZW.html
https://www.zhipin.com/job_detail/aada5386926d1e741nN529m_FFpQ.html
https://www.zhipin.com/job_detail/0fb429cdec8e6d441n1-2ty9GFFX.html
https://www.zhipin.com/job_detail/b0a92e28ad2864d01nB939q7GFFW.html
https://www.zhipin.com/job_detail/dca203abb40850fe1Xd52Ni9EVJZ.html
https://www.zhipin.com/job_detail/1f48b204527e5acd1XZ429-8EFpS.html
https://www.zhipin.com/job_detail/83bd74e126ef50dc1n1729S-FFZX.html
https://www.zhipin.com/job_detail/61783d679696899e1XB42t-6E1NT.html
https://www.zhipin.com/job_detail/41c6057ca97c9ca61Xd93t28GVtV.html
https://www.zhipin.com/job_detail/dfcd2ec78118449f1XZ509i6F1RV.html
https://www.zhipin.com/job_detail/4c28d65b846ef0761XB62dm8GVZX.html
https://www.zhipin.com/job_detail/5a06934be8d8f2f81Xd_2tW1EVZX.html
https://www.zhipin.com/job_detail/0ca28be3ecced56d1XZ-3N69FFtR.html
https://www.zhipin.com/job_detail/3127e0e61831558703Z529m0FVU~.html
https://www.zhipin.com/job_detail/86ea5145982f1dde1Xd63tW_F1pQ.html
https://www.zhipin.com/job_detail/4eded2d2ad4e3a9a1nFz3Nq1FldT.html
https://www.zhipin.com/job_detail/fb353a64138020c01XB63tq0FlJX.html
https://www.zhipin.com/job_detail/aa19c1973d0742281Xd82926GVNT.html
https://www.zhipin.com/job_detail/dc51dd3ecd97ed2a1Xd82dS6F1BZ.html
https://www.zhipin.com/job_detail/4a3258f13236ddb71XZ539m8FVBY.html
https://www.zhipin.com/job_detail/5e988b1083acddf81XZz0tS8EVdV.html
https://www.zhipin.com/job_detail/7d90924f3283ca3c1XB60tm1EFJX.html
https://www.zhipin.com/job_detail/7b88e066f772a0321XV93NS5FFNR.html
https://www.zhipin.com/job_detail/eecb5d0640f1cfde1nN-2tq4GVdQ.html
https://www.zhipin.com/job_detail/8eb2b7736254a42d1XZ92N--EFVQ.html
https://www.zhipin.com/job_detail/b890ec9cbf8239231nxz29-1GFtR.html
https://www.zhipin.com/job_detail/8e4ee8b554ac97361nx-29i8GFNR.html
https://www.zhipin.com/job_detail/ea365e962df098e21XVy0tu-EFdW.html
https://www.zhipin.com/job_detail/3da4f7e270be72421XVz0t6_E1pR.html
```







### URL基本情况

这部分来自深圳市的抓取的工作年限为102的，注意，这里的经验不限，谨慎投递，最好手动看下情况，因为大多要求3年经验但是填的经验不限。

这里没有做对应的数据清洗，谨慎使用。

抓取的不全面，IP被封禁了。。更新，我的账号被封禁了。。不知道什么时候解封。。所以只能用代理ip和无登录抓取了。

所以今天只有这么多了。

```\
https:\\\www.zhipin.com/job_detail/6613c3d90204fb6d1Xdy2t66ElBR.html
https:\\\www.zhipin.com/job_detail/48b025669ce9ff701Xdy3dW4F1FW.html
https:\\\www.zhipin.com/job_detail/8a6fa1db1af12ea21Xdy3d2_ElNQ.html
https:\\\www.zhipin.com/job_detail/83785ba88b1ab2691Xd42927FlBZ.html
https:\\\www.zhipin.com/job_detail/85532dc9e6f135901Xd_2Nm-F1FX.html
https:\\\www.zhipin.com/job_detail/611134a37b945e941XB60tW0EFdZ.html
https:\\\www.zhipin.com/job_detail/3814dbdf527fd3351XZ_3dS-EVVZ.html
https:\\\www.zhipin.com/job_detail/164e083438df30881nF92N-8E1pU.html
https:\\\www.zhipin.com/job_detail/883a47a7961926fc1XZ42tm8FVJQ.html
https:\\\www.zhipin.com/job_detail/198d4cb488c9dce31nB_3tS6FFVW.html
https:\\\www.zhipin.com/job_detail/3f962b560109be691XV60tq_FVFS.html
https:\\\www.zhipin.com/job_detail/2dbb546e383a723f1XB62t21GFJT.html
https:\\\www.zhipin.com/job_detail/fd56497eed579b3d1n1_09i5FFJQ.html
https:\\\www.zhipin.com/job_detail/1930ab8f2fd8b7f61XZz2N61GFZQ.html
https:\\\www.zhipin.com/job_detail/15af2ff46de7fc761XRz39--F1ZU.html
https:\\\www.zhipin.com/job_detail/05219c2ce7e993711Xd80t--FFFX.html
https:\\\www.zhipin.com/job_detail/6e8999a51ddc4cf91nZ729W1F1NR.html
https:\\\www.zhipin.com/job_detail/5a3e9a1e7b51a6401nN509q8GFpW.html
https:\\\www.zhipin.com/job_detail/dcde2bdaeb607df61Xd509W-FVBT.html
https:\\\www.zhipin.com/job_detail/0cc7e990ade5987c1nV_2du0FFFR.html
https:\\\www.zhipin.com/job_detail/49a9371e5ee08b9a1n1-3di_E1VX.html
https:\\\www.zhipin.com/job_detail/3b66c4e8d7f4700e1XB70t65F1FY.html
https:\\\www.zhipin.com/job_detail/97553b98ac5581991n143929FFVY.html
https:\\\www.zhipin.com/job_detail/6185229bfe247c9d1n182N-9FFRR.html
https:\\\www.zhipin.com/job_detail/80db800ba33175501nN40t6-E1BV.html
https:\\\www.zhipin.com/job_detail/ccb80faff3520c251XZ-3NW9FltQ.html
https:\\\www.zhipin.com/job_detail/22ba801c62af4f761Xd-3tm5FVtZ.html
https:\\\www.zhipin.com/job_detail/a2cdd0617d30be251XZ62925FldW.html
https:\\\www.zhipin.com/job_detail/b7369ef393de0bb61nJ_2dW5EFVW.html
https:\\\www.zhipin.com/job_detail/95f6751faae2f75c1nx-2dS4EFdV.html
https:\\\www.zhipin.com/job_detail/59ad5f3c16bfe3020X190tq1FlQ~.html
https:\\\www.zhipin.com/job_detail/487149e9c7f50a4f1Xd629m1F1NY.html
https:\\\www.zhipin.com/job_detail/482ccc44fcda00111Xd-3ty0GVBR.html
https:\\\www.zhipin.com/job_detail/c8e0daf79c760eb21Xx93dq9EVY~.html
https:\\\www.zhipin.com/job_detail/36c12d374071e61c1nR92d67ElNU.html
https:\\\www.zhipin.com/job_detail/ff6fa90b1c45be701XV52tq_GFFT.html
https:\\\www.zhipin.com/job_detail/41d0e44aea57e77f1n183tW9E1RQ.html
https:\\\www.zhipin.com/job_detail/13d4944b23a817081Xd42tW6FVBU.html
https:\\\www.zhipin.com/job_detail/7fd98bf52e0404231XZz0tW6EVVW.html
https:\\\www.zhipin.com/job_detail/6a189b2ec50130ea1Xd70tS8ElVZ.html
https:\\\www.zhipin.com/job_detail/4c0c76cf17f2114f1Xx43N-_Flc~.html
https:\\\www.zhipin.com/job_detail/bc3fac33e8cc4c9b33x_3dy6EVA~.html
https:\\\www.zhipin.com/job_detail/02b3a8a6e7857a8c1XV43tW0EVpR.html
https:\\\www.zhipin.com/job_detail/ae82a9bd365317651XB43Ni9E1NQ.html
https:\\\www.zhipin.com/job_detail/6827e5dabf7898a51XV43du-GVpZ.html
https:\\\www.zhipin.com/job_detail/025ad936657e2d0a1Xd42tq-E1dR.html
https:\\\www.zhipin.com/job_detail/7c7c5650a45626e91XZ709-5FFFW.html
https:\\\www.zhipin.com/job_detail/52622548f8b5e8dd1XR40968F1JU.html
https:\\\www.zhipin.com/job_detail/3a426bf35f02098a1Xd72tm-ElVR.html
https:\\\www.zhipin.com/job_detail/ce7ffc1b5cc4ed5f1XZ_2di0E1RU.html
https:\\\www.zhipin.com/job_detail/018ac64dae08fe781XZ_0tW-ElpS.html
https:\\\www.zhipin.com/job_detail/8fadcb8b6ea919441XV73t-6GVFR.html
https:\\\www.zhipin.com/job_detail/ef2fc03965f4f1d91Xd53dm8ElRV.html
https:\\\www.zhipin.com/job_detail/9625cee96ee1be631nB90tu-ElRU.html
https:\\\www.zhipin.com/job_detail/e874bfc9179d589b1nN4392-EFJX.html
https:\\\www.zhipin.com/job_detail/655a781c3f88dc641XB62t24GVVZ.html
https:\\\www.zhipin.com/job_detail/af9728dd53e4f48e03B639W7FFQ~.html
https:\\\www.zhipin.com/job_detail/cc594395c96d32791nB93d67ElpW.html
https:\\\www.zhipin.com/job_detail/5aa10c2277401a8f1XZ93Nq6ElRR.html
https:\\\www.zhipin.com/job_detail/1547f04d28e3aef41nJy2tS0GFFR.html
https:\\\www.zhipin.com/job_detail/3df31112eb4a901e1XV53tm4GFJU.html
https:\\\www.zhipin.com/job_detail/f9c663fc18ddb0ba1XB72dm4GFpR.html
https:\\\www.zhipin.com/job_detail/b4ebebf165defc061XZz3tq7FFpZ.html
https:\\\www.zhipin.com/job_detail/9ad0d03ecb416bbf1XB629W9EVNS.html
https:\\\www.zhipin.com/job_detail/215984b8f0c94a431XZ529-5GVdV.html
https:\\\www.zhipin.com/job_detail/f6eabbef3ef4aae00HF-2N2-GVQ~.html
https:\\\www.zhipin.com/job_detail/7622d005c82f33b71XR82Ni7FFFV.html
https:\\\www.zhipin.com/job_detail/8f2398eec04738791nJ_2t2-E1NR.html
https:\\\www.zhipin.com/job_detail/9b841f8050ed47251Xd70t-9FFVV.html
https:\\\www.zhipin.com/job_detail/8946176f899fdac71nx83NW-FVNW.html
https:\\\www.zhipin.com/job_detail/df72f8e6e47d0d5d1nZ62Ny7EVdX.html
https:\\\www.zhipin.com/job_detail/c24e3942677bcdad1nF93ti0F1tR.html
https:\\\www.zhipin.com/job_detail/5617e409a43d196a1nd42d-7GVJS.html
https:\\\www.zhipin.com/job_detail/d54551ea6cf758751XZ809i_FldR.html
https:\\\www.zhipin.com/job_detail/576b64bd24f99e931XZ42Ny5FlpY.html
https:\\\www.zhipin.com/job_detail/7b1e02bfc879a8d61nB_29i_FVJT.html
https:\\\www.zhipin.com/job_detail/eb38b3ea6c453cac1Xd909-1FlBX.html
https:\\\www.zhipin.com/job_detail/236651e48fa96ccc1nZz2Ni0E1VX.html
https:\\\www.zhipin.com/job_detail/d2aadbd64b28f54d1XR52Ny4F1pY.html
https:\\\www.zhipin.com/job_detail/2bea91843a3ef9a31Xd_2d27FVtU.html
https:\\\www.zhipin.com/job_detail/e203e07779dc13461nNz29W8FFZY.html
https:\\\www.zhipin.com/job_detail/f09f727a98317b681Xd929u7FlJV.html
https:\\\www.zhipin.com/job_detail/b78536abac8555b01Xd43d21EFBZ.html
https:\\\www.zhipin.com/job_detail/f7b879138e6601a71XV83tu8EFNR.html
https:\\\www.zhipin.com/job_detail/e432b56b595446e41nN7096_E1BT.html
https:\\\www.zhipin.com/job_detail/acfde1846e60e6951Xd63N69F1tU.html
https:\\\www.zhipin.com/job_detail/f6acf79d5eba9a831nJ42N60GVFX.html
https:\\\www.zhipin.com/job_detail/d9e101854bf30cc81XV72t65FlpT.html
https:\\\www.zhipin.com/job_detail/ca3346b6fa7c2f0d1n1_3du7EltR.html
https:\\\www.zhipin.com/job_detail/6cd00535b7351b401XR-2dy-GFBW.html
https:\\\www.zhipin.com/job_detail/9866fa1525c4238a1XZy2tS-ElZZ.html
https:\\\www.zhipin.com/job_detail/96016ea63d50f3541nZ53924FltY.html
https:\\\www.zhipin.com/job_detail/a3a49b7f25da6b7c1XNz29i_EFs~.html
https:\\\www.zhipin.com/job_detail/4c80264fe2b0856e1XZz3du7FFpQ.html
https:\\\www.zhipin.com/job_detail/6467c4e217b2c9921n153dm0EFtU.html
https:\\\www.zhipin.com/job_detail/ed131cadb445c3981Xd529q5FlJU.html
https:\\\www.zhipin.com/job_detail/56775d7824a5c1661nJ_3N68ElpT.html
https:\\\www.zhipin.com/job_detail/87ee523fce7ba3661nF739W-F1VZ.html
https:\\\www.zhipin.com/job_detail/17da0a1b6ecbc4e11Xd42ty8FltZ.html
https:\\\www.zhipin.com/job_detail/fb096ffedfde19371nVz296_GFdZ.html
https:\\\www.zhipin.com/job_detail/e8a892c7d4bfc9b61XB62di-FFpY.html
https:\\\www.zhipin.com/job_detail/7f4f2edbbc3945e21XVz3dm-FldR.html
https:\\\www.zhipin.com/job_detail/016daa3c93a867d81XZy0926FVRS.html
https:\\\www.zhipin.com/job_detail/33ce4ee706484c2a1Xdz29u1EltV.html
https:\\\www.zhipin.com/job_detail/54c50985c0c36e671n162Nu4FlZW.html
https:\\\www.zhipin.com/job_detail/32da7ae35fd7d6bf1nF92N-0EVdW.html
https:\\\www.zhipin.com/job_detail/7697cf394f70bd0e1XR53dW5EFNT.html
https:\\\www.zhipin.com/job_detail/2b79af798728696d1Xd-39q-F1ZZ.html
https:\\\www.zhipin.com/job_detail/ae4de1c27cd9eb7e1Xdy29y_FFJY.html
https:\\\www.zhipin.com/job_detail/2e7e488a27dcabc31Xd839u1EldX.html
https:\\\www.zhipin.com/job_detail/9578bfb9b097582b1XV52dy-F1JV.html
https:\\\www.zhipin.com/job_detail/fdf25b26531895c71Xd52NS8F1pZ.html
https:\\\www.zhipin.com/job_detail/fad68aac9e9896711XB739u7EldW.html
https:\\\www.zhipin.com/job_detail/47f1e7911cf465971Xd93d24FlRW.html
https:\\\www.zhipin.com/job_detail/dd0fd8283e7798ba1XV42Nm0E1dU.html
https:\\\www.zhipin.com/job_detail/598875ff728c20de1XZ40t2_E1pX.html
https:\\\www.zhipin.com/job_detail/db6a59b0809795871XB639y-FVFY.html
https:\\\www.zhipin.com/job_detail/b2d35d977294c3041XV-2Ni0E1RR.html
https:\\\www.zhipin.com/job_detail/2e29ddcb5e7847291XR-2N67E1NR.html
https:\\\www.zhipin.com/job_detail/df2cf742b6d431a61Xd93ty9EVVX.html
https:\\\www.zhipin.com/job_detail/a88d37d0f2985b7d1XZ52Nm8FFJR.html
https:\\\www.zhipin.com/job_detail/304ea2b6f37d633a1XB63NS1FlpZ.html
https:\\\www.zhipin.com/job_detail/b62a6a804327d3601XR63tq6EFRR.html
https:\\\www.zhipin.com/job_detail/bef36df8d7e018871XV729q9ElpS.html
https:\\\www.zhipin.com/job_detail/1e63675c06b5147f1XR42925F1pQ.html
https:\\\www.zhipin.com/job_detail/63bdfbac173fe5021Xdz2Nu4FVZY.html
https:\\\www.zhipin.com/job_detail/7476ff8332838f9a1XB70967FVpW.html
https:\\\www.zhipin.com/job_detail/41dbd5da3096de5a1Xd92Nu5EVpX.html
https:\\\www.zhipin.com/job_detail/bb7de6cc50383e511n1-3t-8EVBZ.html
https:\\\www.zhipin.com/job_detail/e1ed03a7747421981nB509S5GVBS.html
https:\\\www.zhipin.com/job_detail/8a62bde6871db92a1XV73926FVFQ.html
https:\\\www.zhipin.com/job_detail/80a8225526e522821nZ72d61EFtR.html
https:\\\www.zhipin.com/job_detail/6fac1dac51fe4ec31nF42du8FFFS.html
https:\\\www.zhipin.com/job_detail/55d52737b6310e691XV_0ti6GFVT.html
https:\\\www.zhipin.com/job_detail/ae32002eeb899bfd1nN43tW8EFJY.html
https:\\\www.zhipin.com/job_detail/baf606d2bb7614da1XZ839i1E1tS.html
https:\\\www.zhipin.com/job_detail/b4f552c9c29443f01Xd90t66GFFQ.html
https:\\\www.zhipin.com/job_detail/48a7dbb8439a179f1Xd93tm8GVVW.html
https:\\\www.zhipin.com/job_detail/a840ab4da3359ed41Xd92Nu0EFZR.html
https:\\\www.zhipin.com/job_detail/092f982354a0370d1XV72Nu_EFdR.html
https:\\\www.zhipin.com/job_detail/c6bb190eff52633c1Xd_29S8FVJS.html
https:\\\www.zhipin.com/job_detail/af6a7b7106e730251XB70tq7FlpZ.html
https:\\\www.zhipin.com/job_detail/0894fde6611cd2580nRy3ti8ElQ~.html
https:\\\www.zhipin.com/job_detail/4c952f8b61c806bd1XVz09W6ElRQ.html
https:\\\www.zhipin.com/job_detail/11ce4efa7c6c38a11nd73Nu1FFdU.html
https:\\\www.zhipin.com/job_detail/c2cd58587529f3b91nN73dq_GVdY.html
https:\\\www.zhipin.com/job_detail/f113cdd4c374d7941XZy2tS-FVtT.html
https:\\\www.zhipin.com/job_detail/458becef7a01b3841Xd-3d20EVBZ.html
https:\\\www.zhipin.com/job_detail/063bb545bb5a554a1XR839m8E1tW.html
https:\\\www.zhipin.com/job_detail/576e2bf43f5cdb911XRz2t-5ElNV.html
https:\\\www.zhipin.com/job_detail/e72e5aceb6dcf7dd1Xd-2N6_ElJW.html
https:\\\www.zhipin.com/job_detail/276ad3f62c57e2001Xd739W-E1ZS.html
https:\\\www.zhipin.com/job_detail/cfd0f422eb7854f71XZ72Ni8GFVV.html
https:\\\www.zhipin.com/job_detail/bd9d40232260d49b1Xd60t-7GFdQ.html
https:\\\www.zhipin.com/job_detail/49dca13ddeb816fd1XV82tS6FVBW.html
https:\\\www.zhipin.com/job_detail/0b48e0f2f6590c911nZ92du5GFBW.html
https:\\\www.zhipin.com/job_detail/94f9514b8fb1b8941Xd-2ti6EFBR.html
https:\\\www.zhipin.com/job_detail/03a6ad82e994c1cf1XV439S0FVZS.html
https:\\\www.zhipin.com/job_detail/b4c101781ee41f511Xdz2du7FlFQ.html
https:\\\www.zhipin.com/job_detail/3a01d78cdf220e021nVy2d64GVRW.html
https:\\\www.zhipin.com/job_detail/60ba8dd9fe4e77e41Xd92Nu8EFVW.html
https:\\\www.zhipin.com/job_detail/84fd80cdcc0a8c631nZ909u5GFRU.html
https:\\\www.zhipin.com/job_detail/bd11d80730f1a5761nJ40tq7GFNW.html
https:\\\www.zhipin.com/job_detail/99a75aee3f52b9b71XB72dS8GFtW.html
https:\\\www.zhipin.com/job_detail/43c5af88459715871n140t66FVVS.html
https:\\\www.zhipin.com/job_detail/3ebb2502224866ae1nJ-3N67EVpX.html
https:\\\www.zhipin.com/job_detail/b0bd006f5986f04a1Xd72du4EVJT.html
https:\\\www.zhipin.com/job_detail/1c937ef177e2644a1XZ83t6_GVFW.html
https:\\\www.zhipin.com/job_detail/d158824d44fbc8c91XB62ty6EFZS.html
https:\\\www.zhipin.com/job_detail/d130f4a2db6dd2991XZ43t60E1tV.html
https:\\\www.zhipin.com/job_detail/a7a5bdf0c7eb6a911Xd_3Nm9F1FZ.html
https:\\\www.zhipin.com/job_detail/afed97c30821d25b0nJ-396_E1U~.html
https:\\\www.zhipin.com/job_detail/fab6533f7ad79e741Xdz2dm0FVdW.html
https:\\\www.zhipin.com/job_detail/60a6d4e7caa5dc011nZ83t66FldT.html
https:\\\www.zhipin.com/job_detail/93c4216acd39c70a1XZ92Ni8EVZU.html
https:\\\www.zhipin.com/job_detail/fdf9e1129c5411d91nN-29i6FVJY.html
https:\\\www.zhipin.com/job_detail/f826f76569bc02761XZ72NS7EVZY.html
https:\\\www.zhipin.com/job_detail/9642298896280eac1nx_2dy4F1RT.html
https:\\\www.zhipin.com/job_detail/65d1dce7ca0dfcfb1nR-2ty-EFtV.html
https:\\\www.zhipin.com/job_detail/6b69e0f3cecfdc401XZ-3d20F1pZ.html
https:\\\www.zhipin.com/job_detail/4c943aee61dd9a2e1XZ83tq-EltT.html
https:\\\www.zhipin.com/job_detail/526a9969a3e8d73c1XV429y-FVNQ.html
https:\\\www.zhipin.com/job_detail/b911ad93000419e71XR62dS8F1FW.html
https:\\\www.zhipin.com/job_detail/555cb476d87eff281Xd93ty4FFBT.html
https:\\\www.zhipin.com/job_detail/1d9d20e0597e6f061XB709S8GFtU.html
https:\\\www.zhipin.com/job_detail/902084ca3fa67dde1XZ80ty5EVZT.html
https:\\\www.zhipin.com/job_detail/6b63ee5a0a60fa271Xd72Nu0F1JW.html
https:\\\www.zhipin.com/job_detail/f30829141a8e81631XB439W9GFZQ.html
https:\\\www.zhipin.com/job_detail/c81770bf3dddd6191Xd429m6GFFR.html
https:\\\www.zhipin.com/job_detail/e461939d56980e091XB60ti6F1JU.html
https:\\\www.zhipin.com/job_detail/00fa296f601ab8b21Xd43926FFdW.html
https:\\\www.zhipin.com/job_detail/490140631b5a3f061XV92tq7FVBW.html
https:\\\www.zhipin.com/job_detail/18475961e6d295471XZz3N66F1tZ.html
https:\\\www.zhipin.com/job_detail/a062bcb99aa2a46f1XB73dm-F1tV.html
https:\\\www.zhipin.com/job_detail/04015e13d0e300b11XVy3Ni9GVdT.html
https:\\\www.zhipin.com/job_detail/799fc099e3c5f6aa1XV62t-_FVFW.html
https:\\\www.zhipin.com/job_detail/f84f729dc7c790701nJz3dS1FFBX.html
https:\\\www.zhipin.com/job_detail/126574cdeaf8b17a1XR529u9FFNR.html
https:\\\www.zhipin.com/job_detail/50cbf0f3f0d1f0021n1_2Nu_F1FU.html
https:\\\www.zhipin.com/job_detail/ecd019fef9fbb1ee0Xdy3tq1Fw~~.html
https:\\\www.zhipin.com/job_detail/74734fab24eed0761nN50ty-FFFX.html
https:\\\www.zhipin.com/job_detail/2ada21598e0a3ac01nV93Nq_EVZX.html
https:\\\www.zhipin.com/job_detail/562a96e2d8b2407d1XB42ty6EVdX.html
https:\\\www.zhipin.com/job_detail/145f3c752609e2891Xd72du5GFRS.html
https:\\\www.zhipin.com/job_detail/f54b4fbc8d79585b1Xd70967F1pT.html
```




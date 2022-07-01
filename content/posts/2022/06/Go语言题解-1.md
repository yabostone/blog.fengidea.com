---
title: "Go语言题解 1"
date: 2022-06-23T21:09:21+08:00
draft: false		

---

本篇是牛客网go语言题解的部分。

#### 1 fmt

本题是用来了解go语言的基本结构和fmt 打印的基础。

fmt 包内部常见的有 Printf,Println,Sprintf。

#### 2 基本类型

本题用来了解常见的基础类型，常见的基础类型有 bool ,string , int (int8 ,int16,int32,int64,uint8,uint16,uint32,uint64),byte,float32,float64, complex64,complex128。

比较特别的是基础类型包括了complex64 这类复数格式。



```
package main

import (
    "fmt"
)
func main() {
    var name string ="小明";
    var years int = 23;
    var sex bool = true;
    
    fmt.Println(name);
    fmt.Println(years);
    fmt.Println(sex);
}
```

#### 3 结构体

本题考察结构体，需要注意几点：

+ 结构体的类型为`struct` ，并且以`type`开头。
+ 结构体不需要用`var`来修饰
+ 结构体构造的时候`:=` 来自动定义变量类型，同时创建基本类型的时候需要用**大括号{}**，而不是**小括号()**.



题目设置上，需要手动fmt输出每个变量的值。



```go
package main

import  "fmt"

type Person struct{
     name string
     age int 
     gender bool
}

func main() {
    v1 := Person{}
    fmt.Println(v1.name)
    fmt.Println(v1.age)
    fmt.Println(v1.gender)
}
```

#### 4.国家名称

本次学习const的概念和使用，重点是了解const将变量固定，不能发生变化，定义变量后，直接顺序输出就可以了，代码参见。

```go
package main

import  "fmt"

func main() {
  const CN string = "中国"
  const EN string = "英国"
  const US string = "美国"

    
    fmt.Println(CN)
    fmt.Println(EN)
    fmt.Println(US)
}
```

#### 5.使用指针

本题中仅仅是使用指针，

注意\* 的位置， `*int` 表示这个是一个指针，实际上是一个地址，类型为 `<*int>` 。

ptr1 表示一个地址，`*ptr1` 表示地址对应的值。生成指针的时候，赋值为 `&a`

```go
package main

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param a int整型 变量a
 * @param b int整型 变量b
 * @return bool布尔型一维数组
*/
func equal( a int ,  b int ) []bool {
    // write code here
        var ptr1 *int = &a
        var ptr2 *int = &b
        var ret1 bool
        var ret2 bool
        if(*ptr1 == *ptr2){
            ret1 = true
        }else{
            ret1 = false
        }
        if(ptr1 == ptr2){
            ret2 = true
        }else{
            ret2 = false
        }

    return []bool{ret2,ret1}
}
```

#### 6.字符串拼接

本题注意两点，

第一个for range 遍历，默认用key，value 进行遍历，丢弃key。！ 如果需要更改遍历的[]string,需要直接设定s[key]值进行更改，value始终为集合中对应索引的值拷贝，因此它一般只具有只读性质，对它所做的任何修改都不会影响到集合中原有的值。

第二个就是字符串拼接可以直接用+号拼接。

还要注意for 没有括号，延续了python的风格。可以没有分号，延续js的风格。

```Bash
package main
//import "fmt"

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param s string字符串一维数组 
 * @return string字符串
*/
func join( s []string ) string {
    // write code here
    var str1 string
    for _,value := range s{
        str1 += value        
    }
    return str1
}
```

#### 7.字符串转换

+ 简单转换

  + 在高低精度上进行转换，可以用int(),string()的方式

+ 不同类型之间转换，建议用strconv的转换函数

  包括Atoi，string to int方式。

  Itoa  ，int to string 方式

这里取个巧，用的Sprintf方式， Sprintf是将所有的格式化内容转为string形式并返回。Sprintf内置了String()函数进行转换，注意，这里不能循环嵌套使用string函数，只能递归一次。

```go
package main
import "fmt"

/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param x int整型 
 * @return bool布尔型
*/
func isPalindrome( x int ) bool {
    // write code here
    var s string = fmt.Sprintf("%d",x)
    fmt.Println(s)
    length := len(s)
    for i := 0 ; i < length/2 ; i++{
        if s[i] != s[length-i-1]{
            return false
        }
    }
    return true;
    
}
```

#### GP10  字符串求和

这题的重点在 strconv.ParseInt()的使用，

我们看下例子。

```Bash
func ParseInt(s string, base int, bitSize int) (i int64, err error)

```

ParseInt 调入三个值 ，分别是string 的字符串，基础int二进制类型，int的bit大小

示例

```Bash
b, err := strconv.ParseBool("true")
f, err := strconv.ParseFloat("3.1415", 64)
i, err := strconv.ParseInt("-42", 10, 64) //十进制，64位
u, err := strconv.ParseUint("42", 10, 64) //十进制，64位
```



所以本题上的示例代码：



```go
package main
//import "fmt"
import "strconv"
/**
 * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
 *
 * 
 * @param a string字符串 
 * @param b string字符串 
 * @return string字符串
*/
func sum( a string ,  b string ) string {
    // write code here
    aa , _ := strconv.ParseInt(a,10,64)
    bb , _ := strconv.ParseInt(b,10,64)
    
    return strconv.Itoa(int(aa+bb))
    
}
```


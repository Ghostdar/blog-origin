---
title: API设计规范
date: 2017-03-30 00:41:45
category: ['前端']
tag: ['RESTful API','后端']
copyright: true
---
> API(Application Programming Interface,应用程序编程接口)是一些预先定义的函数，目的是提供应用程序与开发人员基于某软件或硬件得以访问一组例程的能力，而又无需访问源码，或理解内部工作机制的细节。简单的说，API就是通过某一预先定义的渠道读/写数据的方式。由于技术的发展，前后分离模式已经成为主流，且前端设备层出不穷，于是为统一前后端通信的机制，WEB API应运而生。下面我就从发起一个请求到返回数据的过程中，聊一聊API的设计规范。

<!-- more -->
## 一. 初识 RESTful API
#### 1. RESTful架构的前世今生：
  REST(Representational State Transfer,表层状态转化)是由是Roy Thomas Fielding(HTTP协议（1.0版和1.1版）的主要设计者、Apache服务器软件的作者之一、Apache基金会的第一任主席)在他2000年的博士论文中提出的，而如果一个架构符合REST原则，那就称之为RESTful架构。

#### 2. 浅析RESTful架构（资源表现层状态转化）：

* 资源：资源即网络上的一个实体，如文本、图片、歌曲，甚至一种服务，也可以称之为资源，而URI(统一资源标识符)是指向某一种资源的唯一标识，我们上网，就是通过URI与某些资源进行互动的过程。

* 表现层：“资源”是一种信息实体，它可以有多种外在表现形式(html、xml、json、jpg等)。我们把“资源”具体呈现出来的形式，叫做它的“表现层”（Representation）。URI只代表资源的实体，不代表它的形式。严格地说，有些网址最后的“.html”后缀名是不必要的，因为这个后缀名表示格式，属于"表现层"范畴，而URI应该只代表"资源"的位置。HTTP请求的头信息中ccept和Content-Type字段用于对“表现层”的描述。

* 状态转化：互联网通信协议HTTP协议是一个无状态协议,状态都保存在服务器端。因此，如果客户端想要操作服务器，必须通过某种手段，让服务器端发生“状态转化”（State Transfer）。而这种转化是建立在表现层之上的，所以就是“表现层状态转化”。客户端用到的手段，就是HTTP协议里面，四个表示操作方式的动词：GET(获取资源)、POST(新建/更新资源)、PUT(更新资源)、DELETE(删除资源)。

#### 3. 总结：
* 一个URI代表一种资源.
* 客户端和服务器之间，传递这种资源的某种表现层.
* 客户端通过四个HTTP动词，对服务器端资源进行操作，实现"表现层状态转化".

## 二. RESTful API的设计规范 
#### 1. URI
* **协议**：

  API与用户的通信协议应为：HTTPS（以安全为目标的HTTP通道，即HTTP下加入SSL层，用于加密和身份验证。）

* **域名**：

  应将API尽量放入专用域名之下：
``` 
    https://api.youwebsite.com 
```
  若只是简单的API且不会继续扩展，可放入主域名之下：
```
    https://youwebsite.com/api/ 
```

* **路径**：
  
  路径是API中的具体网址，在RESTful架构中，每一个网址代表一种资源，所以URL中不能有动词，只能有名词，而且所有的名词一般与数据库中的表名相对应，数据库中每个表都是一种资源的集合，所以API中的名词应该使用负数，如：
  ```
  https://api.youwebsite.com/v1/bookracks    //代表书架的集合
  
  https://api.youwebsite.com/v1/bookracks/category   //代表书架的分类

  https://api.youwebsite.com/v1/manager  //代表书架的管理员
  ```

* **复杂查询**:
<table><tr><th></th><th>示例</th><th>备注</th></tr><tr><td>过滤条件</td><td>?type=1&num=6</td><td>允许一定冗余，如/books/1可以写成/books?id=1</td></tr><tr><td>排序</td><td>?sort=page,desc</td><td></td></tr><tr><td>投影</td><td>?userinfo=id,name,email</td><td></td></tr><tr><td>分页</td><td>?limit=10&offset=3</td><td></td></tr></table>


* **Bookmarker**:
经常使用的、复杂的查询标签化，降低维护成本。如：
```
/trades?status=closed&sort=created,desc

可以写成：

GET /trades/recently-closed

```

#### 2. request 

* **HTTP方法**:

  常用的动词：
  * GET(select): 从服务器取出资源

  * POST(create): 在服务器创建一个资源

  * PUT(update): 在服务器更新资源（客户提供改变后的完整资源，如改变用户的信息）

  * PATCH(update): 在服务器更新资源（客户提供改变的属性，如修改用户的状态）

  * DELETE(delete): 从服务器删除资源

  不常用的动词：
  * HEAD: 获取资源的元数据

  * OPTIONS: 获取信息，关于资源的哪些属性客户是可以改变的

* **header**

  * Content-Type：
    1.Content-Type:application/json
    ```
    POST /v1/animal HTTP/1.1
    Host: api.youwebsite.com
    Accept: application/json
    Content-Type: application/json
    Content-Length: 24

    {   
      "name": "Sir H",
      "age": "12"
    }

    ```
    2.Content-Type:application/x-www-form-urlencoded
    ```
    POST /login HTTP/1.1
    Host: example.com
    Content-Length: 31
    Accept: text/html
    Content-Type: application/x-www-form-urlencoded

    username=sir&password=123456

    ```
    3.Content-Type: multipart/form-data; boundary=—-RANDOM_jDMUxq4Ot5 (表单有文件上传时的格式)

  * **Accpet**:
  资源可以有多种表示方式，如json、xml、pdf、excel等等，客户端可以指定自己期望的格式，通常有两种方式：
  1.http header头重的Accpet字段：
  ```
    Accept:application/xml;q=0.6,application/atom+xml;q=1.0 

    // q 为格式的偏好程度
  ```
  2.url中加文件后缀，如：test.html

  * Cookie
  请求头由cookie字段控制：
  ```
  Cookie:Hm_lvt_3d8e7fc0de8a2a75f2ca3bfe128e6391=1489670554,1490097787,1490798805,1490975802;Hm_lpvt_3d8e7fc0de8a2a75f2ca3bfe128e6391=1490975802; Hm_lvt_079fac161efc4b2a6f31e80064f14e82=1489636957,1490097787,1490798805,1490975802; Hm_lpvt_079fac161efc4b2a6f31e80064f14e82=1490975802
  ```

* **body**
  在请求的正文中使用JSON格式的数据，与返回的格式相对应。

#### 3. response

* **状态码**
  ```
200 OK - [GET]：服务器成功返回用户请求的数据，该操作是幂等的（Idempotent）。

201 CREATED - [POST/PUT/PATCH]：用户新建或修改数据成功。

202 Accepted - [*]：表示一个请求已经进入后台排队（异步任务）

204 NO CONTENT - [DELETE]：用户删除数据成功。

400 INVALID REQUEST - [POST/PUT/PATCH]：用户发出的请求有错误，服务器没有进行新建或修改数据的操作，该操作是幂等的。

401 Unauthorized - [*]：表示用户没有权限（令牌、用户名、密码错误）。

403 Forbidden - [*] 表示用户得到授权（与401错误相对），但是访问是被禁止的。

404 NOT FOUND - [*]：用户发出的请求针对的是不存在的记录，服务器没有进行操作，该操作是幂等的。

406 Not Acceptable - [GET]：用户请求的格式不可得（比如用户请求JSON格式，但是只有XML格式）。

410 Gone -[GET]：用户请求的资源被永久删除，且不会再得到的。

422 Unprocesable entity - [POST/PUT/PATCH] 当创建一个对象时，发生一个验证错误。

500 INTERNAL SERVER ERROR - [*]：服务器发生错误，用户将无法判断发出的请求是否成功

503 service unavaliable - [*]：由容器抛出，自己的代码不要抛这个异常
  ```

* **header**
```
  Cache-Control:max-age=2592000
  Content-Encoding:gzip
  Content-Length:2723
  Content-Type:image/gif
  Date:Fri, 31 Mar 2017 08:33:05 GMT
  Expires:Sun, 30 Apr 2017 08:33:05 GMT
  Last-Modified:Fri, 31 Mar 2017 02:00:00 GMT
  etag:"58dac650-14168"
  expires:Wed, 28 Mar 2018 20:28:15 GMT
  Server:Qnginx/1.3.2
  Timing-Allow-Origin:*

```

* **Content-Type**

 ```
 Content-Type:application/javascript; charset=utf-8

 content-type:text/html; charset=GB18030

 ```
 设置返回的文件类型。

* **缓存(一般不在业务层处理)**
  返回的头部一般由3个字段控制：
  ```
  cache-control:max-age=691200

  last-modified:Sat, 07 Mar 2015 16:28:18 GMT

  etag:W/"fbbd4924d5b6836c48ac099e397dbf7a"

  ```

* **Set-Cookie**
  ```
  set-cookie:username=848760247&848760247; Domain=mail.qq.com; Path=/

  set-cookie:tinfo=1490975913.0000*; Domain=mail.qq.com; Path=/

  set-cookie:wimrefreshrun=0&; Domain=mail.qq.com; Path=/
  ```
  Set-Cookie字段控制返回的cookie信息。

* **body**
  返回的数据一般为json格式。


* **json规范**
    * 基本结构
        * 状态：
        ```
        {
            "status":"success",
        }
        ```
        返回的json中含有判断状态的标识。

        * 提示：
        返回的数据中应有请求的提示信息字段。
         ```
        {
            "msg":"your password is not ture",
        }
        ```

        * data（如分页设计：page，pageSize，total, totalPage）
        ```
        {
            "multipart-page":{
              "page":"1",
              "pagesize":"10",
              "total":"8",
              "totalpage":"2"
            }
        }
        ```
    * 深度限制：
    数据的深度层级一般在4-6层之间。
    
#### 4. 字段规范

* **时间**
 返回的时间一般都是UTC格式，ISO8601格式的数据，如：
 ```
  {
    "create-time":"2017-3-31T12:00:00Z"
  }
 ```

* **编码**

字段中的特殊字符，html标签都应转化为实体字符。

* **超链接**

最好做到Hypermedia，即返回结果中提供链接，连向其他API方法，使得用户不查文档，也知道下一步应该做什么。

#### 5. 错误处理
  1.不要发生了错误但给2xx响应，客户端可能会缓存成功的http请求；
  2.正确设置http状态码，不要自定义；
  3.Response body 提供错误的代码（日志/问题追查）和错误的描述文本（展示给用户）。

* **业务型异常**
>由自己的业务代码抛出，表示一个用例的前置条件不满足、业务规则冲突等，比如参数校验不通过、权限校验失败
业务类异常必须提供2种信息：
  * 如果抛出该类异常，HTTP 响应状态码应该设成什么；
  * 异常的文本描述
* **非业务型**
>表示不在预期内的问题，通常由类库、框架抛出，或由于自己的代码逻辑错误导致，比如数据库连接失败、空指针异常、除0错误等等

在Controller层使用统一的异常拦截器：

  1.设置 HTTP 响应状态码：对业务类异常，用它指定的 HTTP code；对非业务类异常，统一500；

  2.Response Body 的错误码：异常类名

  3.Response Body 的错误描述：对业务类异常，用它指定的错误文本；对非业务类异常，线上可以统一文案如“服务器端错误，请稍后再试”，开发或测试环境中用异常的 stacktrace，服务器端提供该行为的开关

#### 6. 安全
  API的身份认证应该使用OAuth 2.0框架。

参考了几篇文章之后，自己的总结，可能不是很完善。
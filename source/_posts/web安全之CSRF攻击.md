---
title: web安全之CSRF攻击
date: 2017-03-28 23:08:32
category: '前端'
tag: ['web安全']
copyright: true
---
> CSRF(Cross Site Request Forgery,跨站请求伪造)攻击是一种依赖web浏览器的、被混淆过的代理人攻击，通过伪装来自受信任用户的请求来利用受信任的网站，造成个人隐私泄露及财产安全。

<!--more-->

那么，CSRF攻击是怎样的流程呢？

<img src="/img/CSRF攻击图解.png" />

1. step1: 客户端向网站A发起了通信请求

2. step2: 网站A验证通过，并建立了通信连接，在客户端保存了A的cookie.

3. step3: 客户端在未关闭与A的连接的情况下访问了网站B.

4. step4: 网站B含有恶意请求代码，要求向网站A发起请求.

5. step5：客户端根据B发起的请求并携带已保存的网站A的cookie访问网站A.

6. step6: 网站A验证cookie并处理了这个请求.

于是，网站B就通过盗用保存在客户端的cookie，以客户端的身份来访问网站A，做一些诸如：发送信息，邮件，盗取账户，财产等违法操作。</br>

由于我们现在使用的都是多窗口的浏览器，例如chorme、firefox、360浏览器等等。在带来方便的同时，也方便了CSRF的攻击，因为多窗口的浏览器都是单进程的，每个窗口的会话是共享的，所以会话信息很容易被利用。</br>

那么，如何预防CSRF呢？其实防范CSRF的思想都是一致的，就是增加伪随机数(token)的验证。

1. 通过 referer、token 或者 验证码 来检测用户提交.例如：

 * 在<meta>标签加入token：
    ```
    <meta content="_csrf" name="csrf-param">
    <meta content="6eEHcEur-Q-CoC0eMc3GIRofusFMhD6fYr4Y" name="csrf-token">
    ```
 * 在表单加入token:
    ```
    <input type="hidden" name="csrf_token" value="<? echo $token;?>">
    ```
 * 请求操作要求输入验证码.(ps：这个一定程度上会影响用户体验)

2. 尽量不要在页面的链接中暴露用户隐私信息.

3. 尽量使用post进行表单提交.

4. 避免全站通用的cookie，严格设置cookie的域.


目前来说，做好以上几点，几乎能防范99%的CSRF攻击啦。哈哈~
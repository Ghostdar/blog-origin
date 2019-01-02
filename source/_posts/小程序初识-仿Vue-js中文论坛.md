---
title: 小程序初识--仿Vue.js中文论坛
date: 2017-08-15 17:06:02
category: '前端'
tag: ['vue','wechat','前端']
copyright: true
---

> 小程序的秉承着 “体验极简化”、“用完即走” 的理念应运而生。许久之前，我就对小程序的个人版的推出满怀期待，想做点小玩意儿体验一下小程序，而后又忙于工作，没有付诸行动，如今在找工作期间得闲，花了4天，基于[Vue.js中文论坛](https://vue-js.com/)提供的开发接口，开发了论坛的小程序版。

<!-- more -->

### 1. 主要功能：

- 论坛帖子查看、收藏
- 登陆发布新帖子
- 评论和消息管理

### 2. 目录结构

```
|——README.md          <= 项目介绍
|——app.js             <= 主要逻辑文件
|——app.json           <= 全局配置文件
|——app.wxss           <= 公共样式文件 
|——component          <= 组件库
|  |——timeTeanslate   <= 时间格式转换组件
|  |——wxParse         <= 富文本解析组件
|  |——weui            <= weui样式库
|——pages              <= 页面文件
|  |——detail
|  |——index           
|  |——user
|  |——api.js          <= 接口文件
|  |——const.js        <= 常量定义文件
|——static             <= 静态资源
   |——image
```
### 3. 效果演示

3.1 主页

<img src="/img/vue(2).png" style="width:322px;">

3.2 文章详情

<img src="/img/vue(4).png" style="width:322px;">

3.3 登陆

<img src="/img/vue(1).png" style="width:322px;">

3.4 个人中心

<img src="/img/vue(6).png" style="width:322px;">

3.5 发布文章

<img src="/img/vue(3).png" style="width:322px;">

3.6 我的收藏

<img src="/img/vue(5).png" style="width:322px;">

3.7 我的消息

<img src="/img/vue(7).png" style="width:322px;">


### 4.总结

#### 4.1 小程序的基本功能

- 小程序的文件类型：

```
js ---------- 主要逻辑
json -------- 项目配置文件，负责窗口颜色等等
wxml ------- 类似HTML文件
wxss ------- 类似CSS文件

```

- 创建一个页面：

在page文件夹下创建一个页面的文件夹，里面新建4个必要的基本文件，然后再app.json中配置路由：

```
{
  "pages":[
    "pages/index/index",
    "pages/detail/detail",
    "pages/user/user/user",
    "pages/user/login/login",
    "pages/user/message/message",
    "pages/user/collect/collect",
    "pages/user/newtopic/newtopic"
  ]
}

```

- 发起一个API请求：


```
    wx.request({
      url: API.API.Post_mark_all,    // 请求url
      method: 'POST',                // 请求方式
      data: {
        'accesstoken': token         // 参数
      },
      success: function (res) {
        if (res.data.success) {
          wx.showToast({
            title: '标记成功',
            icon: 'success',
            duration: 1000
          })
          that.getMessage()
        }else {
          wx.showToast({
            title: res.data.error_msg,
            icon: 'success',
            duration: 1000
          })
```

- 本地缓存
由于没有类似Vuex的状态管理工具，一些公用的数据保存在本地缓存中，例如登陆的状态、accesstoken、用户的信息等。
操作本地缓存的方法有：

```
// 设置
wx.setStorage()   //异步
wx.setStorageSync() //同步
// 获取
wx.getStorage()   //异步
wx.getStorageSync() //同步
//清除
wx.clearStorage()   //异步
wx.clearStorageSync() //同步

```

- 页面的生命周期的方法：

``` 
onLoad   //页面加载
onReady  //页面渲染完成
onShow   //页面显示
onHide   //页面隐藏
onUnload  //页面卸载
```


#### 4.2 未实现的功能 

由于时间原因,以下2个功能尚未完成:

- 针对于某个特定用户的回复功能

- 点赞功能

#### 4.3 有待优化的地方

- 文章的富文本解析

- 小程序的状态管理

#### 4.4 个值得推荐的组件和库

- wxParse 富文本解析组件
- weui   微信官方UI库

#### 最后
项目的github地址：[https://github.com/Ghostdar/wechat-weapp-vueForum]("https://github.com/Ghostdar/wechat-weapp-vueForum")

欢迎 ```star!```
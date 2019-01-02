---
title: 浅析 Apache 工作原理
date: 2017-04-01 23:32:29
category: '后端'
copyright: true
tag: ['Apache','web服务器','后端']
---
> Apache是目前世界上使用最为广泛的一种Web Server，它以跨平台、高效和稳定而闻名。那么Apache是怎样工作的呢？

<!-- more -->
## 一、LAMP架构

说起apache，那就不得不了解一下LAMP架构，LAMP架构是较为流行的一套建站架构，因其通用、跨平台、高性能、低价格的优势，无论是性能、质量还是价格都是企业搭建网站的首选平台。

<img src="/img/LAMP架构.png"/>


* Linux 操作系统底层

* Apache 服务器，属于次级服务器，沟通Linux和php
 
* PHP 服务端脚本语言，使用php_module模块与Apache服务器关联，

* Mysql 和 Web Aplication (其他web服务)，使用php_extensions 模块相关联


## 二、Apache 生命周期

<center><img src="/img/Apache生命周期.png"/></center>


* 启动阶段：Apache解析配置文件（如http.conf以及Include指令设定的配置文件等），模块加载(例如mod_php.so,mod_perl.so等)和系统资源初始化（例如日志文件、共享内存段等）工作。在这个阶段，Apache为了获得系统资源最大的使用权限，将以特权用户root（X系统）或超级管理员administrator(Windows系统)完成启动。

* 运行阶段：在这个阶段，Apache为了获得系统资源最大的使用权限，将以特权用户root（X系统）或超级管理员administrator(Windows系统)完成启动。分11个阶段处理用户的请求。

## 三、Apache 处理请求的过程

<img src="/img/Apache请求处理过程.png"/>
* Post-Read-Request阶段：读取request头部信息。

* URI Translation阶段：将请求的URL映射到本地文件系统，mod_alias模块就是在这个阶段工作

* Header Parsing阶段：解析header头部，mod_setenvif在这个阶段工作

* Access Control阶段：按照配置文件设定的策略对用户进行认证，并设定用户名区域，模块可以在这阶段实现认证方法。

* Authorization阶段：根据配置文件检查是否允许认证过的用户执行请求的操作，模块可以在这阶段实现用户权限管理的方法

* MIME Type Checking阶段 ：根据请求资源的MIME类型的相关规则，将文件交由相应的处理模块。

* Fix Up 阶段：模块在内容生成器之前，运行必要的处理流程

* Response阶段 ：生成响应报文。

* Logging阶段 ：在响应客户端后记录事务

* CleanUp阶段 ：清除请求后遗留的环境，如文件、目录的处理或者Socket的关闭等。


## 四、Apache 的两种工作模式

#### 1.什么是MPM

  MPM（Multi-Processing Modules，多路处理模块）是Apache的核心组件之一，Apache通过MPM来使用操作系统的资源，对进程和线程池进行管理。Apache为了能够获得更好的运行性能，针对不同的平台 (Unix/Linux、Window)提供了不同的MPM，用户可以根据实际情况进行选择，其中最常使用的MPM有 prefork和worker两种。

#### 2.Prefork

  * 工作原理：Prefork是非线程、预生成进程型MPM，会预先启动一些子进程，每个子进程一个时间只能处理一个请求，并且会根据并发请求数量动态生成更多子进程
  * 配置参数：
    ```
    StartServices    服务器启动默认启动的子进程；

    MinSpareServers    最小空闲进程数量；

    MaxSpareServers    最大空闲进程数量；

    MaxClients     最高的并发量；

    ServerLimit    最大限制的并发量；

    MaxRequestsPerChild      每个子进程默认最多处理多少个请求。当达到设定值时，这个进程就会被kill掉，重新生成一个新的进程（避免内存泄露等安全性问题，运行太久怕出一些bug，可能出现假死，或者占用太多内存等）；
    ```
#### 3.worker
  * Workder是线程化、多进程的MPM，每个进程可以生成多个线程，每个线程处理一个请求；不需要启用太多的子进程,每个进程能够拥有的线程数量是固定的。服务器会根据负载情况增加或减少进程数量。一个单独的控制进程(父进程)负责子进程的建立。每个子进程能够建立ThreadsPerChild数量的服务线程和一个监听线程，该监听线程监听接入请求并将其传递给服务线程处理和应答。

  * 配置参数：
    ```
    StartServers 服务器启动时建立的子进程数，默认值是"3"。

    MaxClients  允许同时服务的最大接入请求数量(最大线程数量)。任何超过MaxClients限制的请求都将进入等候队列，默认值是"400"。

    MinSpareThreads 最小空闲线程数,默认值是"75"。

    MaxSpareThreads  设置最大空闲线程数。默认值是"250"。

    ThreadsPerChild  每个子进程建立的常驻的执行线程数。默认值是25

    MaxRequestsPerChild  设置每个子进程在其生存期内允许处理的最大请求数量。

    ```

#### 4.Prefork和Worker的比较

  1. prefork方式速度要稍高于worker，然而它需要的cpu和memory资源也稍多于woker。

  2. prefork的无线程设计在某些情况下将比worker更有优势：它可以使用那些没有处理好线程安全的第三方模块，并且对于那些线程调试困难的平台而言，它也更容易调试一些。

  3. 在一个高流量的HTTP服务器上，Worker MPM是个比较好的选择，因为Worker MPM的内存使用比Prefork MPM要低得多。
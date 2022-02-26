---
title: 网站SSL与HTTPS访问设置
date: 2022-02-26 18:13:53
categories: 经验
tags:
  - 经验
  - 安全
  - 网络
cover: https://pic.outspace.tech/images/2022/02/26/729603921.jpg
---



# 网站 `SSL` 证书与 `HTTPS` 访问设置



> 现在的互联网环境中，一个网站没有 `HTTPS` 安全访问那可能真是要让人笑掉了大牙。而要建立安全访问，首要任务就是要申请到可信机构办法的 `SSL` 数字证书。
>
> 本文就记录了我为网站下属的几个域名加设 `HTTPS` 访问的全过程。

<br>



## Chapter 1 `SSL` 证书申请

在网站初次建立时，我满足于能看得着就行，并没有太过关注安全访问相关的事宜。但是最近的每次访问中，浏览器地址栏总是显示的**不安全**字样以及偶尔出现的**非安全链接**的阻止页面让人非常心烦。

这次就下定决心要完成全站的安全改造工作。

1. 首先需要在阿里云的免费 SSL 证书申请页中获取申请资格。

   > 每位用户可以每年免费获得二十个一级域名的证书资格。

   <img src="https://pic.outspace.tech/images/2022/02/26/-2022-02-26-183003.png" alt="证书购买页" style="zoom:80%;" />

   这些免费证书对于一个小网站也足够了。

2. 完成后就可以在免费证书的页面申请了，我的证书签发商是 `digicert` 使用 RSA 算法签发的。

   ![证书申请结果页](https://pic.outspace.tech/images/2022/02/26/-2022-02-26-183219.png)

3. 需要注意的是在申请过程中的 DNS 验证需要被验证的一级域名完成自动校验，其会将一个自动生成的 TXT 型解析记录加入主域名中。

   > 在本环节中我踩了许多坑：
   >
   > - 证书需要在全站都不开启 `HTTPS` 访问的情况下申请。
   > - 在域名管理处不要加入诸如 `pic.outspace.tech` 之类的子域名，这会导致验证失败。
   > - 需要在主域名下添加主机记录为 `pic` 的 `A` 类解析记录。
   > - 修改 `TXT` 解析记录相对于新建一个记录的生效时间要慢得多，导致不能立即验证成功。
   > - 服务器防火墙需要放行 `443` 端口。

4. 完成验证后，证书一般会很快签发，至此 `SSL` 证书申请的工作结束。

<br>



## Chapter 2 证书部署与 `HTTPS` 服务设置

获得签发的证书一般有 `.pem` 与 `.key` 两个文件，需要将两个文件全部加入 `Nginx` 的 `SSL` 设置中。

比较推荐的上传位置是 `/etc/Nginx/cert` 中。

> 我的 `Nginx` 服务器是在 `apt` 中安装的，所以面对网上乱做一团的教程，大多都不适用，这也在安装过程中给我带来了极大的困难。

完成上传后，如果 `Nginx` 是通过 `apt` 安装的，那么 `openssl` 已经内置，否则需要按照网络指导，添加模块编译选项后完成可执行程序的重新编译。

接下来就是在 `conf` 文件中完成 `ssl` 的配置：

```conf
server {
	# 设置监听端口 开启 SSL
    listen 443 ssl;
    listen [::]:443 ssl default_server;
    # 主页
    index    index.html;
	# 识别的域名
    server_name outspace.tech www.outspace.tech;
    charset utf-8;
    root /home/git/blog;
    error_page 404 /404.html;

    # 跨域文件头
    location / {
        add_header Access-Control-Allow-Origin "*";
        add_header Access-Control-Allow-Methods, "POST, GET, PUT, OPTIONS, DELETE";
        add_header Access-Control-Allow-Headers, "Origin, X-Requested-With, Content-Type, Accept, x-token";

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    # SSL 设置
    # 其中 ssl on; 配置已经废弃
    
    # 设置部署的证书文件
    ssl_certificate cert/www/7315946_outspace.tech.pem;
    ssl_certificate_key cert/www/7315946_outspace.tech.key;
	
	# 其他 SSL 配置
    ssl_session_timeout 5m;
    ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
    ssl_prefer_server_ciphers on;

}
```

完成后对 `nginx` 改动进行应用。

```bash
nginx -t
nginx -s reload
```

<br>



## Chapter 3 效果总结

访问网站终于有小锁了！没有烦人的安全警告了！ :rocket: :rocket: :rocket:

![Chrome 安全检查](https://pic.outspace.tech/images/2022/02/26/image-20220226185000562.png)

本次折腾还有以下的遗憾：

- 没有完成 `http` 到 `https` 的访问转发，进行了试验的几种方式都不可行。
- `Firefox` 的测试中，总是会出现跨域访问被拒绝的问题，目前无法查出问题原因。












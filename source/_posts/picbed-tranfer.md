---
title: Chevereto 自建图床
date: 2022-02-26 16:25:31
categories: 经验
tags:
  - 经验
  - 图床
  - Nginx
cover: https://pic.outspace.tech/images/2022/02/26/729603921.jpg
---



# Chevereto 自建图床



> 一直一来就觉得 `Github` 图床除了在免费方面，不管是在实用性上还是便利性上都不算上佳。本次我就抓住机会，借助濒临弃坑的`Chevereto-free` 框架，彻底将图床建在了自己服务器上。



## Chapter 1 框架选择



在进行了一段时间的网上冲浪之后，发现在自建图床这一领域，现有所有的帖子都在推荐 `Chevereto` 这一图床框架。该框架的商业版已经出到了 `V4` 并且要价不菲。

![ Chevereto 的定价页面](https://pic.outspace.tech/images/2022/02/26/-2022-02-26-163749.png)

在进一步了解之后，发现框架的开发者还提供了开源的 `Chevereto-free` ，网址如下：https://github.com/rodber/chevereto-free。

框架全部由 `PHP` 写成，然后通过 `jQuery` 的技术栈，确实一看就是有一定年份的软件了，但是这不妨碍它的设计理念完全符合一个自建图床的人的绝大部分需求。

<br>



## Chapter 2 后端设置



### 2.1 `Nginx ` 后端设置

在此之前，云服务器上仅仅设置了 `www` 与 `webdav` 子域名分别用于博客主页的展示与简单的文件网盘。对于图床应用，本次我继续新建了一个二级域名 `pic` 专门用于图床，注意需要在对应的云服务器提供商那里设置新的 `A` 类型 DNS 解析记录。

```conf
server {
    listen 80;

    server_name pic.outspace.tech;
    root /usr/www/picbed/public_html;

    # Disable access to sensitive application files
    location ~* (app|content|lib)/.*\.(po|php|lock|sql)$ {
        return 404;
    }
    location ~* composer\.json|composer\.lock|.gitignore$ {
        return 404;
    }
    location ~* /\.ht {
        return 404;
    }

    # Image not found replacement
    location ~* \.(jpe?g|png|gif|webp)$ {
        log_not_found off;
        error_page 404 /content/images/system/default/404.gif;
    }

    # CORS header (avoids font rendering issues)
    location ~* \.(ttf|ttc|otf|eot|woff|woff2|font.css|css|js)$ {
        add_header Access-Control-Allow-Origin "*";
    }

    # PHP front controller
    location / {
        index index.php;
        try_files $uri $uri/ /index.php$is_args$query_string;
    }
    
    # Single PHP-entrypoint (disables direct access to .php files)
    location ~* \.php$  {
        internal;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }
}
```

在处理过程中实在是饱尝了不看官方文档的各种恶果，依据网上各种混乱的代码甚至都配不齐框架所依赖的 `php-extensions` 扩展包。

> 官方文档如下：https://v3-docs.chevereto.com/setup/server/requirements.html#php

上述代码是在官方文档的指导下，完成了包括跨域 (CORS)，`php-fastcgi` 等的设置。

后续我还将开启 `Https` 访问的 `443` 端口。



而在后续的检查过程中，我发现 `Nginx` 服务器也对上传的文件大小有隐藏限制，反复测试下应该在 `1M` 左右。所以在 `etc/nginx/nginx.conf` 总设置文件中，需要显式增加文件大小。

```conf
client_max_body_size 512M;
```



### 2.2 `PHP` 设置

在固定位置的 `php.ini` 总设置文件中，我们可以设置 `php` 一方的文件上传大小。

```ini
upload_max_filesize = 50M;
post_max_size = 50M;
max_execution_time = 30;
memory_limit = 512M;
```

此外，由于`Nginx` 服务器并不内置对于 `php` 的支持，需要安装框架本身依赖在内的一众扩展插件。

```sh
sudo apt install php-common php-fileinfo php-mysql php-gd php-mbstring php-pdo php-imagick php-pdo-mysql php-xml php-fpm php-cli php-zip
```

然后启动 `php` 服务 :

```bash
service php-fpm start
```



### 2.3 数据库设置

`Chevereto` 对于 `MySQL` 的 5.7 与 8.0 版本都予以支持。如果初次安装的话，可以进行如下操作：

```bash
sudo apt install mysql-server
sudo mysql_secure_installation
```

通过该脚本的指示，就可以一步一步地完成初始化的账号密码设置等安全工作。

以 `root` 身份登录 `MySQL - cli` 之后，进行以下工作：

```mysql
create database chevereto;
create user 'chevereto' identified by 'your password';
grant all priviledges on chevereto.* to 'chevereto';
```

 完成图床数据库的创建与用户授权工作。



### 2.4 `Chevereto` 框架安装

直接使用 `wget` 命令从 `github realease` 中获取框架文件。

> 需要注意的是，作者在 1.5.0 版本开始移除的多语言的支持，并在后续版本中还移除了批量导入的支持。

```bash
mkdir /usr/www/picbed
cd /usr/www/picbed
wget https://github.com/rodber/chevereto-free/releases/download/1.6.2/1.6.2.zip
```

解压后改变文件安全设置，以便框架对自身有操作权限。

```bash
unzip 1.6.2.zip
sudo chmod -R 777 /usr/www/picbed
```

<br>



## Chapter 3 前端设置

### 3.1 框架初始化设置

在完成后端的部署之后，直接访问在 `nginx` 中配置的域名，即可出现如下初始化设置界面：

<img src="https://pic.outspace.tech/images/2022/02/26/20200218090832769.jpg" style="zoom: 50%;" />

这样完成数据库的连接与管理员账号的设置之后就可以开始使用啦。详细设置可以通过 `Dashbord` 中的设置页面完成。

![个人资料页面](https://pic.outspace.tech/images/2022/02/26/-2022-02-26-172615.png)



### 3.2 图片相关的自定义设置

该框架所使用的图片在框架目录的 `./content/images/system` 中，通过替换相应的内容，可以自定义网站的 `Logo` ，主页图片，网站小图标等等。

![网站 Logo](https://pic.outspace.tech/images/2022/02/26/logo_1000.png)

由用户上传的图片内容则以上传时间戳存储在`./image` 目录中。



### 3.3 协作上传设置

可以使用 PicGo 作为本地的上传客户端，无需登录网页即可进行图片管理。

在其插件市场中，可以搜索到 `Chevereto Uploader` 插件，安装后重启软件即可看到相关设置：

- 首先上传 `Url` 是相对固定的：`https://pic.outspace.tech/api/1/upload`
- 第二行中的 `Key` 是在 `Dashboard -> Settings -> API -> API V1 密钥`的传输凭证。

完成设置后，需要注意的是若想指定上传的用户，对于个人模式来说，需要更改如下源文件。

```bash
cp ./app/routes/route.api.php ./app/routes/overide/route.api.php
```

通过内置的覆盖机制完成修改

```php
// ./app/routes/overide/route.api.php

// CHV\Image::uploadToWebsite($source, 'username', [params]) to inject API uploads to a given username
        $uploaded_id = CHV\Image::uploadToWebsite($source, 'xw1216', array('album_id'=> 1));
```

 一般在原代码参数后面加上用户名与需要上传的相册 ID 。



> 需要准确指定相册 ID ，否则就会上传图像就会传入到在相册页不可见的用户默认相册。

<br>



## Chapter 4 效果总结

在进行一系列的自定义后，图床网站的效果如下：

![图床主页效果图](https://pic.outspace.tech/images/2022/02/26/-2022-02-26-174125.jpg)



这次可算是把心心念念的图床搞完啦 :smile: ，总体来看效果非常好，在做图床的同时还能当成图片的存储来用。

但是也有下面的不足：

- 云服务器的公网下行带宽太小了，加载图片总是要很长时间。
- 跨域请求在 `Chrome` 中通过了，但是在`Firefox` 中，跨域的图片请求头中甚至连 `Access-Control-Allow-Origin` 这一条目都没有，可能与 `Firefox` 自身的安全机制有关，或者是归功于 `Chrome ` 的强大纠错能力。

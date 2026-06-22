# Xiaolan-CDN-Node

## 环境要求：

x86-64架构的 Debian 10~13 或 Ubuntu 18~24（Ubuntu理论支持，未测试）

MySQL 5.7及以上

## 安装：

### 一键安装：

```Bash
wget -O Xiaolan-CDN-Node-V0.1.0-Install.sh https://github.com/Xiaolan2333/Xiaolan-CDN-Node/releases/download/Xiaolan-CDN-Node-V0.1.0/Xiaolan-CDN-Node-V0.1.0-Install.sh && chmod 777 Xiaolan-CDN-Node-V0.1.0-Install.sh && ./Xiaolan-CDN-Node-V0.1.0-Install.sh
```

### 编译安装（此处以V0.1.0作演示）：

1.安装依赖

```Bash
apt install unzip wget build-essential libgd-dev libxslt-dev libxml2-dev -y
```

2.新建文件夹并进入文件夹

```Bash
mkdir ./xiaolan-cdn && cd ./xiaolan-cdn
```

3.下载源码压缩包

```Bash
wget https://raw.githubusercontent.com/Xiaolan2333/Xiaolan-CDN-Node/refs/heads/main/src/src.zip
```

4.解压压缩包

```Bash
unzip src.zip
```

5.编译并安装LuaJIT

```Bash
cd ./module/luajit2-2.1-20250826/ && make -j$(nproc) && make install && cd .. && cd ..
```

6.编译并安装Nginx

```Bash
./configure --prefix=/opt/xiaolan-cdn/xiaolan-cdn-node --build=Xiaolan-CDN-Node-V0.1.0 --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_v3_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_ssl_preread_module --with-pcre-jit --with-compat --with-pcre=./module/pcre2-10.47 --with-zlib=./module/zlib-1.3.2 --with-openssl=./module/openssl-3.5.7 --with-ld-opt="-L/usr/local/lib -Wl,--whole-archive -l:libluajit-5.1.a -Wl,--no-whole-archive -lm -ldl" --add-module=./module/ngx_devel_kit-0.3.4 --add-module=./module/lua-nginx-module-0.10.31 && make -j$(nproc) && make install
```

7.安装Lua库的小组件

```Bash
cd ./module/lua-resty-core-0.1.34rc3/ && make install PREFIX=/opt/xiaolan-cdn/xiaolan-cdn-node && cd .. && cd lua-resty-lrucache-0.15 && make install PREFIX=/opt/xiaolan-cdn/xiaolan-cdn-node && cd .. && cd ..
```

8.设置目录权限

```Bash
chmod 777 -R /opt/xiaolan-cdn
```

9.设置Systemd配置文件

```Bash
cat > /etc/systemd/system/xiaolan-cdn-node.service << 'EOF'
[Unit]
Description=Xiaolan-CDN-Node
After=network.target

[Service]
Type=forking
PIDFile=/opt/xiaolan-cdn/xiaolan-cdn-node/logs/nginx.pid
ExecStart=/opt/xiaolan-cdn/xiaolan-cdn-node/sbin/nginx
ExecReload=/opt/xiaolan-cdn/xiaolan-cdn-node/sbin/nginx -s reload
ExecStop=/opt/xiaolan-cdn/xiaolan-cdn-node/sbin/nginx -s stop
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
```

10.启动服务

```Bash
systemctl daemon-reload && systemctl enable xiaolan-cdn-node --now
```

11.清理源码文件

```Bash
cd .. && rm -r xiaolan-cdn
```

至此，安装完成

## 其它：

### 其它命令：

查看服务状态：

```Bash
systemctl status xiaolan-cdn-node
```

重启服务：

```Bash
systemctl stop xiaolan-cdn-node
```

### 管理系统仓库地址：
[https://github.com/Xiaolan2333/Xiaolan-CDN-System](https://github.com/Xiaolan2333/Xiaolan-CDN-System)
#!/bin/bash
echo "Xiaolan-CDN节点安装脚本"
echo "安装所需运行库"
apt update
apt install wget libgd-dev unzip -y
echo "安装完成"
echo "创建目录"
mkdir /opt/xiaolan-cdn
mkdir /opt/xiaolan-cdn/xiaolan-cdn-node
echo "创建目录完成"
echo "下载压缩包"
wget -P /opt/xiaolan-cdn/xiaolan-cdn-node https://github.com/Xiaolan2333/Xiaolan-CDN-Node/releases/latest/download/Xiaolan-CDN-Node.zip
echo "压缩包下载完成"
echo "解压压缩包"
unzip /opt/xiaolan-cdn/xiaolan-cdn-node/Xiaolan-CDN-Node.zip -d /opt/xiaolan-cdn/xiaolan-cdn-node
chmod -R 777 /opt/xiaolan-cdn/xiaolan-cdn-node
echo "解压完成"
echo "设置Systemd配置文件"
cat > /etc/systemd/system/xiaolan-cdn-node.service << 'EOF'
[Unit]
Description=Xiaolan-CDN-Node
Documentation=https://xiaolan2333.github.io
After=network.target remote-fs.target nss-lookup.target

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
echo "设置Systemd配置文件成功"
echo "启动Nginx"
systemctl daemon-reload
systemctl enable xiaolan-cdn-node --now
echo "清理临时文件"
rm /opt/xiaolan-cdn/xiaolan-cdn-node/Xiaolan-CDN-Node.zip
echo "清理完成"
echo "节点安装完成"
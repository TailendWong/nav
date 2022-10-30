#!/bin/bash

# nginx
apt-get install build-essential libtool libpcre3 libpcre3-dev zlib1g-dev libssl-dev \
&& wget http://nginx.org/download/nginx-1.21.6.tar.gz \
&& tar -xvf nginx-1.21.6.tar.gz && useradd nginx && cd nginx-1.21.6 \
&& ./configure --prefix=/usr/local/nginx \
--user=nginx --group=nginx \
--with-http_gzip_static_module \
--with-http_flv_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_mp4_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-pcre --with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
&& make && make install && ln -s /usr/local/nginx/sbin/nginx /usr/bin/


# docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
groupadd docker && gpasswd -a $USER docker && newgrp docker && mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://w0pc1i5g.mirror.aliyuncs.com",
    "http://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://dockerproxy.com"
  ],
  "max-concurrent-downloads": 10
}
EOF
systemctl daemon-reload && systemctl restart docker

# mysql8
docker pull mysql:8.0.27
mkdir -p /data/app/docker_volumn/mysql/conf
mkdir -p /data/app/docker_volumn/mysql/data
mkdir -p /data/app/docker_volumn/mysql/mysql-files
docker run -p 3306:3306 --name=mysql \
-v /data/app/docker_volumn/mysql/conf/:/etc/mysql/ \
-v /data/app/docker_volumn/mysql/data:/var/lib/mysql \
-v /data/app/docker_volumn/mysql/mysql-files/:/var/lib/mysql-files \
-e MYSQL_ROOT_PASSWORD=_root \
-d --privileged=true --restart=always mysql:8.0.27 --lower-case-table-names=2

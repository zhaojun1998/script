#!/bin/bash

# usage: curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/master/docker-install.sh | bash

# 判断当前机器的 ip 地址, 备用选项: cip.cc
is_china_ip=$(curl -sSL http://myip.ipip.net | grep '中国' | wc -l | tr -d "[:space:]" )

# 安装 docker, 如果是国内的 ip，就使用国内的镜像源
# 如国内使用 curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun，国外使用 curl -fsSL https://get.docker.com | bash
if [[ $is_china_ip -eq 1 ]]; then
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
else
  curl -fsSL https://get.docker.com | bash
fi

# 安装 docker-compose
tag=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo curl -L "https://github.com/docker/compose/releases/download/${tag}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

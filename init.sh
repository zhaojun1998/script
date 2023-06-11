#!/bin/bash

## Author: ZhaoJun
## Usage:
#     curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/init.sh | bash
#     curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/init.sh | bash -s -- --change-mirror --install-zsh --setup-vim --install-docker

#     curl -fsSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/init.sh | bash
#     curl -fsSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/init.sh | bash -s -- --change-mirror --install-zsh --setup-vim --install-docker
## Github: https://github.com/zhaojun1998/script
## Function: 一键安装 zsh, vim, docker, 并且配置好 vim 和 zsh 的插件和主题, 一般用于新机器的初始化

set -e

######################################################################################################
# environment configuration
######################################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
PLAIN='\033[0m'

######################################################################################################
# function
######################################################################################################

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  command_exists sudo || return 1
  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

change_mirror() {
  echo -e "${GREEN}开始更换镜像源${PLAIN}"
  curl -fsSL https://linuxmirrors.cn/main.sh | sudo -E bash -s -- \
    --source mirrors.tuna.tsinghua.edu.cn \
    --web-protocol http \
    --intranet false \
    --install-epel false \
    --close-firewall false \
    --backup true \
    --updata-software false \
    --clean-cache false \
    --ignore-backup-tips
}

install_zsh() {
  echo -e "${GREEN}开始安装 zsh${PLAIN}"
  if [[ $is_china_ip -eq 1 ]]; then
    curl -fsSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/install/zsh.sh | bash
  else
    curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/install/zsh.sh | bash
  fi
}

setup_vim() {
  echo -e "${GREEN}开始配置 vim${PLAIN}"
  if [[ $is_china_ip -eq 1 ]]; then
    curl -fsSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/vim-setup.sh | bash
  else
    curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/vim-setup.sh | bash
  fi
}

install_docker() {
  echo -e "${GREEN}开始安装 docker${PLAIN}"
  if [[ $is_china_ip -eq 1 ]]; then
    export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
  fi
  curl -fsSL https://get.docker.com/ | sudo -E sh
}

######################################################################################################
# main
######################################################################################################

if ! user_can_sudo; then
  echo -e "${RED}Error: this installer needs the ability to run commands as root.${PLAIN}"
  exit 1
fi

# 判断当前机器的 ip 地址是否是国内, 备用选项: cip.cc
is_china_ip=$(curl -sSL http://myip.ipip.net | grep '中国' | wc -l | tr -d "[:space:]")

if [[ $is_china_ip -eq 1 ]]; then
  echo -e "${GREEN}当前机器的 ip 地址是国内的 ip 地址${PLAIN}，将使用镜像来加速整个过程"
else
  echo -e "${GREEN}当前机器的 ip 地址是国外的 ip 地址${PLAIN}"
fi

if [[ "$#" -eq 0 ]]; then
  # 如果没有传入参数则默认执行全部函数
  change_mirror
  install_zsh
  setup_vim
  install_docker
else
  while [[ $# -gt 0 ]]; do
    case $1 in
    --change-mirror)
      change_mirror
      ;;
    --install-zsh)
      install_zsh
      ;;
    --setup-vim)
      setup_vim
      ;;
    --install-docker)
      install_docker
      ;;
    *)
      echo -e "${RED}Error: unknown option $1.${PLAIN}"
      exit 1
      ;;
    esac
    shift
  done
fi
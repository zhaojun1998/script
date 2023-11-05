#!/bin/bash

## Author: ZhaoJun
## Usage: curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/install/zsh.sh | bash
## Usage(China): curl -fsSL https://gh.zhaojun.im.com/github.com/zhaojun1998/script/blob/main/install/zsh.sh | bash
## Github: https://github.com/zhaojun1998/script
## Function: 一键安装 oh-my-zsh, 并配置好常用插件, 主题, 别名. 脚本可以重复执行, 会自动更新插件、别名，并安装配置脚本中新增的插件、别名

set -e

######################################################################################################
# environment configuration
######################################################################################################

ZSH_THEME="random"
GITHUB_PROXY=""

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
export RUNZSH=yes

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
PLAIN='\033[0m'

# 定义默认插件列表
PLUGINS=(
  z
  git
  docker
  docker-compose
  sudo
  extract
  jsontools
  kubectl
  colored-man-pages
)

# 定义别名列表
alias_list=(
    "alias ll='ls -alFh'"
    "alias la='ls -A'"
    "alias l='ls -CF'"
     "alias dk='docker'"
)

# 判断当前机器的 ip 地址是否是国内, 备用选项: cip.cc
IS_CHINA_IP=$(curl -sSL http://myip.ipip.net | grep '中国' | wc -l | tr -d "[:space:]" )
GITHUB_PROXY=$(if [ $IS_CHINA_IP -eq 1 ]; then echo "https://gh.zhaojun.im.com/"; fi)

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

install_dependency() {
  # 判断使用 apt 还是 yum，安装 zsh git curl
  if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y zsh git curl
  elif command -v yum >/dev/null 2>&1; then
    sudo yum update -y
    sudo yum install -y zsh git curl
  fi
}

install_zsh() {
  # 安装 oh-my-zsh. 判断是否是中国的 ip，如果是就使用国内的镜像源
  if [[ $IS_CHINA_IP -eq 1 ]]; then
    echo -e "${GREEN}Use china mirror source to install oh-my-zsh${PLAIN}"
    sh -c "$(curl -fsSL ${GITHUB_PROXY}https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
      | sed "s|^REPO=.*|REPO=\${REPO:-mirrors/oh-my-zsh}|g" \
      | sed "s|^REMOTE=.*|REMOTE=\${REMOTE:-https://gitee.com/\${REPO}.git}|g")" \
      "" --unattended
  else
    echo -e "${GREEN}Use github source to install oh-my-zsh${PLAIN}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

# 安装插件
install_or_upgrade_zsh_plugin() {
  local repo=$1
  local name=$(basename "$repo" ".git")
  local repo_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$name"
  if [ ! -d "$repo_dir" ]; then
    echo -e "${GREEN}Installing oh-my-zsh plugin: $name${PLAIN}"
    git clone --depth=1 ${repo} "$repo_dir"
    echo 1
  else
    echo -e "${YELLOW}Upgrade oh-my-zsh plugin: $name${PLAIN}"
    cd "$repo_dir" && git pull --rebase
    echo 0
  fi
}

set_alias() {
  for alias_str in "${alias_list[@]}"; do
      if ! grep -q "$alias_str" "$HOME/.zshrc"; then
          echo "$alias_str" >> "$HOME/.zshrc"
          echo -e "${GREEN}Add alias to .zshrc: $alias_str${PLAIN}"
      else
          echo -e "${YELLOW}Alias already exists: $alias_str${PLAIN}"
      fi
  done
}

######################################################################################################
# main
######################################################################################################

if ! user_can_sudo; then
  echo -e "${RED}Error: this installer needs the ability to run commands as root.${PLAIN}"
  exit 1
fi

# 安装相关依赖
install_dependency

# 安装 zsh
install_zsh

# 安装插件
install_or_upgrade_zsh_plugin ${GITHUB_PROXY}https://github.com/zsh-users/zsh-syntax-highlighting.git && PLUGINS+=('zsh-syntax-highlighting')
install_or_upgrade_zsh_plugin ${GITHUB_PROXY}https://github.com/zsh-users/zsh-autosuggestions && PLUGINS+=('zsh-autosuggestions')
install_or_upgrade_zsh_plugin ${GITHUB_PROXY}https://github.com/zsh-users/zsh-history-substring-search && PLUGINS+=('zsh-history-substring-search')

# 调用 install_or_upgrade_zsh_plugin 函数，并根据返回值判断是否要执行命令
if install_or_upgrade_zsh_plugin ${GITHUB_PROXY}https://github.com/zsh-users/zsh-completions | grep -q '^1$'; then
  echo 'fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src' >> ~/.zshrc
fi

# 配置插件列表插件
for plugin in "${PLUGINS[@]}"; do
  if ! grep -q "^plugins=.*$plugin" ~/.zshrc; then
    sed -i "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/" ~/.zshrc
  fi
done

# 修改主题
sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$ZSH_THEME\"/g" ~/.zshrc

# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e "/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST" ~/.zshrc

# 设置别名
set_alias

# 设置 zsh 为默认 shell
if user_can_sudo; then
  sudo -k chsh -s /bin/zsh "$USER"  # -k forces the password prompt
else
  chsh -s /bin/zsh "$USER"          # run chsh normally
fi

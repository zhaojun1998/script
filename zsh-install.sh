#!/bin/bash

# usage: curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/master/zsh-setup.sh | bash

theme="random"
github_proxy=""

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
export RUNZSH=yes

# 判断当前机器的 ip 地址是否是国内, 备用选项: cip.cc
is_china_ip=$(curl -sSL http://myip.ipip.net | grep '中国' | wc -l | tr -d "[:space:]" )
github_proxy=$(if [ $is_china_ip -eq 1 ]; then echo "https://ghproxy.com/"; fi)

# 判断使用 apt 还是 yum，安装 zsh git curl
if command -v apt >/dev/null 2>&1; then
  apt update
  apt install -y zsh git curl
elif command -v yum >/dev/null 2>&1; then
  yum install -y update
  yum install -y zsh git curl
fi

# 安装 oh-my-zsh. 判断是否是中国的 ip，如果是就使用国内的镜像源
if [[ $is_china_ip -eq 1 ]]; then
  sh -c "$(curl -fsSL ${github_proxy}https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended \
    | sed 's|^REPO=.*|REPO=${REPO:-mirrors/oh-my-zsh}|g' \
    | sed 's|^REMOTE=.*|REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}|g')"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi


# 配置插件列表插件
plugins=(
  z
  git
  docker
  sudo
  extract
  jsontools
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)
for plugin in "${plugins[@]}"; do
  if ! grep -q "^plugins=.*$plugin" ~/.zshrc; then
    sed -i "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/" ~/.zshrc
  fi
done

# 安装插件
git clone --depth=1 ${github_proxy}https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
git clone --depth=1 ${github_proxy}https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
git clone --depth=1 ${github_proxy}https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search
git clone --depth=1 ${github_proxy}https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions || true
echo 'fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src' >> ~/.zshrc

# 修改主题为 random，将这个值声明为变量，方便后续修改
sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$theme\"/g" ~/.zshrc

# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e "/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST" ~/.zshrc

# 定义别名列表
alias_list=(
    "alias ll='ls -alFh'"
    "alias la='ls -A'"
    "alias l='ls -CF'"
    "alias dkp='docker-compose'"
    "alias dk='docker'"
)
for alias_str in "${alias_list[@]}"; do
    if ! grep -q "$alias_str" "$HOME/.zshrc"; then
        echo "$alias_str" >> "$HOME/.zshrc"
    else
        echo "Alias already exists: $alias_str"
    fi
done

chsh -s /bin/zsh
#!/bin/bash

## Author: ZhaoJun
## Usage: curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/main/vim-setup.sh | bash
## Usage(China): curl -fsSL https://gh.zhaojun.im/github.com/zhaojun1998/script/blob/main/vim-setup.sh | bash
## Github: https://github.com/zhaojun1998/script
## Function: Setup vim

set -e

######################################################################################################
# environment configuration
######################################################################################################

VIMRC_PATH="$HOME/.vimrc"

######################################################################################################
# main
######################################################################################################

cat <<EOF >> "$VIMRC_PATH"

syntax on

set number
set ruler
set autoindent
set hlsearch
set smartcase
set showmatch
set mouse-=a

EOF

echo "Vim setup complete."

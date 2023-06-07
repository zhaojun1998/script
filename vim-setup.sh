#!/bin/bash

# usage: curl -fsSL https://raw.githubusercontent.com/zhaojun1998/script/master/vim-setup.sh | bash


vimrc_path="$HOME/.vimrc"

cat <<EOF >> "$vimrc_path"

syntax on

set number
set ruler
set autoindent
set hlsearch
set smartcase
set showmatch

EOF

echo "Vim setup complete."
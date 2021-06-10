#!/bin/bash
set -e

if ! command -v pyenv > /dev/null; then
    yum install -y git gcc zlib-devel bzip2 bzip2-devel readline-devel \
        sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    curl -s https://pyenv.run | bash
    if [[ ! -d ~/dotfiles ]]; then # 配合 dotfiles
        cat >> ~/.bashrc << "EOF"
# pyenv
if [[ -d $HOME/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
EOF
    fi
    source ~/.bashrc
fi

echo pyenv version: $(pyenv --version | cut -d" " -f2)

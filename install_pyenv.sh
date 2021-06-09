#!/bin/bash
set -e

if ! command -v pyenv > /dev/null; then
    yum install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel
    curl -s https://pyenv.run | bash
else
    echo pyenv version: $(pyenv --version | cut -d" " -f2)
fi

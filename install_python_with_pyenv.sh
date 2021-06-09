#!/bin/bash
set -e

if [[ -f .python-version ]]; then
    INSTALL_PYTHON_VERSION=$(cat .python-version)
fi
INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:-3.9.5}
COMPILE_SQLITE_SOURCE_FILENAME=sqlite-autoconf-3350500.tar.gz

mkdir -p src

# https://www.sqlite.org/download.html
# Update: 20210608
compile_sqlite() {
    if [[ -f /usr/local/lib/libsqlite3.so ]]; then return; fi

    sqlite_source_filename=${1:-sqlite-autoconf-3350500.tar.gz}
    sqlite_source_dirname=${sqlite_source_filename%%.*}
    pushd src
    if [[ ! -f $sqlite_source_filename ]]; then
        wget https://www.sqlite.org/2021/$sqlite_source_filename
    fi
    if [[ -d $sqlite_source_dirname ]]; then
        rm -fr $sqlite_source_dirname
    fi
    tar xzf $sqlite_source_filename
    chown -R $(whoami). $sqlite_source_dirname
    cd $sqlite_source_dirname
    ./configure
    make && make install
    rm -fr $sqlite_source_dirname
    popd
}

compile_python_with_sqlite() {
    compile_sqlite sqlite-autoconf-3350500.tar.gz
    LD_RUN_PATH=/usr/local/lib pyenv install -v $INSTALL_PYTHON_VERSION
}

py_sqlite_version=$(python -c "import sqlite3; print(sqlite3.sqlite_version)")
py_sqlite_minor_version=$(echo $py_sqlite_version | awk -F. '{print$2}')

# django 3.2.x 依赖 sqlite 3.9.0 以上版本
if [[ $py_sqlite_minor_version -lt 9 ]]; then
    if command -v pyenv > /dev/null; then
        compile_python_with_sqlite
    fi
else
    echo Python version: $(python -V | cut -d" " -f2)
    echo sqlite3.sqlite_version: $py_sqlite_version
fi

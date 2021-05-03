#!/bin/sh

: ${PYTHON=python3}
export XDG_CACHE_HOME=$PWD/.cache

set -e

pip_cache_dir=$XDG_CACHE_HOME/pip
pip_cmd="$PYTHON -m pip install --cache-dir $pip_cache_dir"
$PYTHON -m venv --clear .venv
. .venv/bin/activate
$pip_cmd -U pip setuptools
$pip_cmd -r requirements.txt

git submodule update --init --recursive -- git-cinnabar
make -C git-cinnabar SYSTEM=Linux

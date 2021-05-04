#!/bin/sh

: ${PYTHON=python3}
export PATH=$PWD/git-cinnabar:$PATH
export XDG_CACHE_HOME=$PWD/.cache

set -e

. .venv/bin/activate

name=$1
url=$2

if test x"$name" = x; then
    echo >&2 "push: remote name is required"
    exit 1
fi
if test x"$url" = x; then
    echo >&2 "push: remote url is required"
    exit 1
fi
if ! test -d octave || ! test "$(git -C octave rev-parse --is-bare-repository)" = true; then
    echo >&2 "push: must run pull first"
    exit 1
fi

if git -C octave remote | grep "^$name$" >/dev/null; then
  git -C octave remote set-url "$name" "$url"
else
  git -C octave remote add "$name" "$url"
fi
git -C octave push "$name" default main stable tag "rc-*" tag "release-*" tag "ss-*"

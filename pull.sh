#!/bin/sh

: ${PYTHON=python3}
export PATH=$PWD/git-cinnabar:$PATH
export XDG_CACHE_HOME=$PWD/.cache

set -e

. .venv/bin/activate

git init --bare octave
git -C octave config cinnabar.experiments python3

if ! git -C octave remote | grep "^origin$" >/dev/null; then
  git -C octave remote add origin hg::https://hg.savannah.gnu.org/hgweb/octave
fi
git -C octave config remote.origin.cinnabar-refs bookmarks,tips
git -C octave fetch origin bookmarks/@:default bookmarks/@:main branches/stable:stable
git -C octave cinnabar fsck

if ! git -C octave remote | grep "^tags$" >/dev/null; then
  git -C octave remote add tags hg::tags:
fi
git -C octave fetch --tags tags

git -C octave fsck
git -C octave repack -a -d -f
git -C octave gc

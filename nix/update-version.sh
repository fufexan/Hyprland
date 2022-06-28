#!/usr/bin/env bash

# run this manually; doesn't work in GitHub Actions

set -euxo pipefail

REGEX="([0-9]+(\.[0-9a-zA-Z]+)+)"

CRT_REV=$(git show-ref --tags --head --abbrev | head -n 1 | head -c 7)
TAG_REV=$(git show-ref --tags --abbrev | tail -n 1 | head -c 7)
CRT_VER=$(sed -nEe "/$REGEX/{p;q;}" meson.build | awk -F\' '{print $2}')
VERSION=$(git show-ref --tags --abbrev | tail -n 1 | tail -c +20)

if [[ $TAG_REV = $CRT_REV ]] || [[ $CRT_VER != $VERSION ]]; then
  sed -Ei "s/$REGEX/$VERSION/g" meson.build
  sed -Ei "s/$REGEX/$VERSION/g" flake.nix
fi

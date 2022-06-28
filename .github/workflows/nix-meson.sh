#!/bin/sh

set -euxo pipefail

REGEX="([0-9]+(\.[0-9a-zA-Z]+)+)"

CRT_REV=$(git show-ref --tags --head --abbrev | head -n 1 | head -c 7)
TAG_REV=$(git show-ref --tags --abbrev | tail -n 1 | head -c 7)
CRT_VER=$(sed -nEe "/$REGEX/{p;q;}" meson.build | awk -F\' '{print $2}')
VERSION=$(git show-ref --tags --abbrev | tail -n 1 | tail -c +20)

printf "current commit: $CRT_REV
latest tag commit: $TAG_REV
current version: $CRT_VER
latest version: $VERSION\n\n"

if [[ $TAG_REV = $CRT_REV ]] || [[ $CRT_VER != $VERSION ]]; then
  echo "running command: sed -Ei \"s/$REGEX/$VERSION/g\" meson.build"
  sed -Ei "s/$REGEX/$VERSION/g" meson.build

  echo "running command: sed -Ei \"s/$REGEX/$VERSION/g\" flake.nix"
  sed -Ei "s/$REGEX/$VERSION/g" flake.nix
fi

#!/usr/bin/env bash

# run this manually; doesn't work in GitHub Actions

set -euxo pipefail

REGEX="([0-9]+(\.[0-9a-zA-Z]+)+)"
CRT_VER=$(sed -nEe "/$REGEX/{p;q;}" meson.build | awk -F\' '{print $2}')

sed -Ei "s/$REGEX/$VERSION/g" meson.build
sed -Ei "s/$REGEX/$VERSION/g" flake.nix

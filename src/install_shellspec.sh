#!/usr/bin/env bash
#
# Install latest ShellSpec

# unofficial strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Install latest ShellSpec
curl \
    --fail \
    --location https://git.io/shellspec \
    --show-error \
    --silent \
    | sh -s -- --yes
# Below, we want replacement without expansion so we use single quotes
# shellcheck disable=SC2016
sed --in-place '1s/^/export PATH="$HOME\/.local\/bin:$PATH"\n/' ~/.profile
"$HOME/.local/lib/shellspec/shellspec" --init

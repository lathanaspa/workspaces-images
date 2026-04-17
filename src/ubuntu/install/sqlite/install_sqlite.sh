#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends sqlite3

apt-get clean
rm -rf /var/lib/apt/lists/*
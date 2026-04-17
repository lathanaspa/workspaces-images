#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev \
  build-essential

apt-get clean
rm -rf /var/lib/apt/lists/*
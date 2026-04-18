#!/usr/bin/env bash
set -e

echo "Updating package list..."
apt-get update

echo "Installing prerequisites..."
apt-get install -y \
    curl \
    ca-certificates \
    git \
    bash

echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Claude Code install finished."
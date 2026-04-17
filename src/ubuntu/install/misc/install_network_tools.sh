#!/usr/bin/env bash
set -e

echo "Updating package list..."
apt-get update

echo "Installing curl, wget, and SSH client..."
apt-get install -y \
    curl \
    wget \
    openssh-client

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Done."
#!/usr/bin/env bash
set -e

echo "Updating packages..."
apt-get update

echo "Installing Python and dependencies..."
apt-get install -y \
    python3 \
    python3-pip \
    wget \
    unzip \
    curl

echo "Installing Selenium..."
pip3 install selenium

echo "Installing Chromium and driver..."
apt-get install -y chromium-browser chromium-chromedriver || \
apt-get install -y chromium chromium-driver

pip3 install selenium

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Selenium installation complete."
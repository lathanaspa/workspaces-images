#!/usr/bin/env bash
set -e

echo "Updating packages..."
apt-get update

echo "Installing system dependencies for Playwright..."
apt-get install -y \
    curl \
    wget \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils

echo "Installing Node.js (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

echo "Installing Playwright..."
npm install -g playwright

echo "Installing Playwright browsers..."
npx playwright install --with-deps

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Playwright installation complete."
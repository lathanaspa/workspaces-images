#!/usr/bin/env bash
set -e

echo "Updating packages..."
apt-get update

echo "Installing prerequisites..."
apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    git

echo "Installing Node.js (required for Codex)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

echo "Installing ChatGPT Codex CLI..."
npm install -g @openai/codex

echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Codex CLI installation complete."
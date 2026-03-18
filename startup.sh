#!/bin/bash
set -e

echo "=== Starting GCP free VM setup ==="

# Update packages
apt-get update -y

# SSH server (pre-installed on Ubuntu GCP images, ensure it's enabled)
apt-get install -y openssh-server
systemctl enable ssh
systemctl start ssh
echo "SSH server ready."

# Install Node.js LTS via NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs
echo "Node.js $(node --version) installed."
echo "npm $(npm --version) installed."

# Install Claude Code CLI (Anthropic)
npm install -g @anthropic-ai/claude-code
echo "Claude Code installed: $(claude --version 2>/dev/null || echo 'installed')"

# Install Gemini CLI (Google)
npm install -g @google/gemini-cli
echo "Gemini CLI installed: $(gemini --version 2>/dev/null || echo 'installed')"

echo "=== Setup complete ==="

#!/bin/bash
# install.sh for wcpm (with curl)

set -e

# === EDIT THESE URLs ===
WCPM_URL="https://pkg.world-compute.com/wcpm.sh"
REPO_URL="https://yourdomain.com/packages.tar.gz"  # Optional

# === Download wcpm script ===
echo "[+] Downloading wcpm..."
curl -fsSL "$WCPM_URL" -o wcpm

# === Make it executable ===
chmod +x wcpm

# === Install to /usr/local/bin ===
echo "[+] Installing to /usr/local/bin..."
sudo install wcpm /usr/local/bin/wcpm

# === (Optional) Download and extract package repo ===
echo "[+] Downloading package repository..."
mkdir -p /usr/local/share/wcpm
curl -fsSL "$REPO_URL" -o /tmp/packages.tar.gz
sudo tar -xzf /tmp/packages.tar.gz -C /usr/local/share/wcpm

echo "[+] wcpm installed successfully!"
echo "[*] Try running: wcpm install <package>"

#!/bin/bash
# install.sh — WCPM Installer (with progress, curl, and repo support)

set -e

# === Configuration ===
WCPM_URL="https://pkg.world-compute.com/wcpm.sh"
REPO_URL=""   # Set to empty string "" if unused
INSTALL_DIR="/usr/local/share/wcpm"
BIN_PATH="/usr/local/bin/wcpm"
TEMP_DIR="/tmp/wcpm-install"

# === Colors ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# === Functions ===
countdown() {
    echo -e "${YELLOW}[*] Installing... Please wait...${RESET}"
    for i in {20..1}; do
        printf "\r    %2d seconds remaining..." "$i"
        sleep 1
    done
    echo -e "\r    ${GREEN}Done!                        ${RESET}"
}

die() {
    echo -e "\n${RED}Error:${RESET} $1" >&2
    exit 1
}

banner() {
    echo -e "${GREEN}"
    echo "==================================="
    echo "       WCPM - Installer"
    echo "==================================="
    echo -e "${RESET}"
}

# === Start Installation ===
banner
mkdir -p "$TEMP_DIR"

echo "[+] Downloading wcpm..."
curl -fsSL "$WCPM_URL" -o "$TEMP_DIR/wcpm" || die "Failed to download wcpm.sh"

echo "[+] Making it executable..."
chmod +x "$TEMP_DIR/wcpm"

echo "[+] Installing to /usr/local/bin..."
sudo install "$TEMP_DIR/wcpm" "$BIN_PATH"

# === Optional: Package Repository ===
if [[ -n "$REPO_URL" ]]; then
    echo "[+] Downloading package repository..."
    mkdir -p "$INSTALL_DIR"

    curl -fsSL "$REPO_URL" -o "$TEMP_DIR/packages.tar.gz" || die "Failed to download package repository."

    # Check if file is actually gzip format
    if file "$TEMP_DIR/packages.tar.gz" | grep -q 'gzip compressed'; then
        echo "[+] Extracting repository to $INSTALL_DIR..."
        sudo tar -xzf "$TEMP_DIR/packages.tar.gz" -C "$INSTALL_DIR"
    else
        echo "[!] Warning: Repository file is not gzip. Skipping extraction."
    fi
else
    echo "[*] No repository URL set. Skipping package repo setup."
fi

# === Countdown "Install animation" ===
countdown

echo -e "\n${GREEN}[✔] wcpm installed successfully!${RESET}"
echo "[*] You can now run: wcpm install <package>"

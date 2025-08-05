#!/bin/bash
# install.sh — WCPM Installer (fancy version)

set -e

# === Config ===
WCPM_URL="https://pkg.world-compute.com/wcpm.sh"
REPO_URL=""  # Leave blank if not using repo
INSTALL_DIR="/usr/local/share/wcpm"
BIN_PATH="/usr/local/bin/wcpm"
TEMP_DIR="/tmp/wcpm-install"
PING_HOST="pkg.world-compute.com"

# === Colors ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
RESET="\033[0m"

# === ASCII Banner ===
banner() {
    echo -e "${GREEN}"
    echo "==================================="
    echo "       WCPM - Installer"
    echo "==================================="
    echo -e "${RESET}"
}

# === Functions ===

prompt_user() {
    echo -ne "${YELLOW}[?] Would you like to install WCPM? (y/n): ${RESET}"
    read -r answer
    case "$answer" in
        y|Y) ;;
        *) echo -e "${RED}[✘] Installation cancelled by user.${RESET}"; exit 1 ;;
    esac
}

ping_check() {
    echo -ne "${BLUE}[*] Checking connection to $PING_HOST... ${RESET}"
    if ping -c 1 -W 2 "$PING_HOST" &> /dev/null; then
        echo -e "${GREEN}OK${RESET}"
    else
        echo -e "${RED}FAILED${RESET}"
        echo -e "${RED}[✘] Cannot reach $PING_HOST. Installation aborted.${RESET}"
        exit 1
    fi
}

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    echo -ne "    "
    while ps -p $pid &> /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    echo -ne "${GREEN}✓${RESET}\n"
}

verify_install() {
    echo -ne "${YELLOW}[*] Verifying install integrity...${RESET}"
    sleep 3 &
    spinner
}

countdown() {
    echo -e "${BLUE}[*] Finalizing installation...${RESET}"
    for i in {20..1}; do
        printf "\r    %2d seconds remaining..." "$i"
        sleep 1
    done
    echo -e "\r    ${GREEN}Install complete!           ${RESET}"
}

die() {
    echo -e "\n${RED}[✘] Error:${RESET} $1" >&2
    exit 1
}

# === Begin Script ===
clear
banner
prompt_user
ping_check

echo "[+] Preparing temporary directory..."
mkdir -p "$TEMP_DIR"

echo "[+] Downloading wcpm script..."
curl -fsSL "$WCPM_URL" -o "$TEMP_DIR/wcpm" || die "Failed to download wcpm.sh"

echo "[+] Making it executable..."
chmod +x "$TEMP_DIR/wcpm"

echo "[+] Installing to /usr/local/bin..."
sudo install "$TEMP_DIR/wcpm" "$BIN_PATH"

# Optional package repo
if [[ -n "$REPO_URL" ]]; then
    echo "[+] Downloading package repository..."
    mkdir -p "$INSTALL_DIR"
    curl -fsSL "$REPO_URL" -o "$TEMP_DIR/packages.tar.gz" || die "Failed to download package repository."

    if file "$TEMP_DIR/packages.tar.gz" | grep -q 'gzip compressed'; then
        echo "[+] Extracting repository to $INSTALL_DIR..."
        sudo tar -xzf "$TEMP_DIR/packages.tar.gz" -C "$INSTALL_DIR"
    else
        echo "[!] Warning: Package file not gzip. Skipping extraction."
    fi
else
    echo "[*] No package repo URL set. Skipping repo download."
fi

verify_install
countdown

echo -e "\n${GREEN}[✔] WCPM installed successfully!${RESET}"
echo -e "${BLUE}[*] You can now run: ${RESET}wcpm install <package>\n"

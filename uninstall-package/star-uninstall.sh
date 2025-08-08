#!/bin/bash

set -e

# === METADATA ===
PKG_NAME="cmatrix"
LOG_FILE="/var/lib/wcpm/packages/${PKG_NAME}.list"

# === COLORS ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# === ASCII HEADER ===
banner() {
    echo -e "${RED}"
    echo "╔═══════════════════════════════════════╗"
    echo "║      Uninstalling Package: star       ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
}

# === Confirm Uninstall ===
read -p "❓ Do you want to uninstall '$PKG_NAME'? [y/N]: " confirm
confirm="${confirm,,}"
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo -e "${YELLOW}⚠️  Uninstall canceled.${RESET}"
    exit 0
fi

# === Start ===
clear
banner

echo -e "${YELLOW}[*] Checking installed files...${RESET}"

if [[ -f "$LOG_FILE" ]]; then
    echo -e "${YELLOW}🗑️  Removing installed files listed in:${RESET} $LOG_FILE"
    while read -r file; do
        if [[ -e "$file" ]]; then
            echo -e "  🔸 Removing: $file"
            sudo rm -f "$file"
        fi
    done < "$LOG_FILE"
    sudo rm -f "$LOG_FILE"
    echo -e "${GREEN}[✔] Uninstallation complete!${RESET}"
else
    echo -e "${RED}⚠️  No install log found for '$PKG_NAME'. Attempting manual uninstall...${RESET}"
    echo -e "${YELLOW}➤ Attempting \`sudo make uninstall\` manually (if supported)...${RESET}"

    # Re-clone and attempt make uninstall
    TEMP_DIR="/tmp/wcpm-uninstall-$PKG_NAME"
    rm -rf "$TEMP_DIR"
    https://github.com/n0b0dy-arch-btw/star.git "$TEMP_DIR"
    cd "$TEMP_DIR"

    if autoreconf -i && ./configure && sudo make uninstall; then
        echo -e "${GREEN}[✔] Uninstalled using make uninstall.${RESET}"
    else
        echo -e "${RED}❌ make uninstall failed. Manual cleanup may be needed.${RESET}"
        exit 1
    fi
fi

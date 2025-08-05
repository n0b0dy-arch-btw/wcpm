#!/bin/bash

set -e

# === CONFIGURATION ===
BASE_URL="https://pkg.world-compute.com/packages"
UNINSTALL_URL="https://pkg.world-compute.com/uninstall-package"
TMP_DIR="/tmp/wcpm"
mkdir -p "$TMP_DIR"

# === COLORS ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
RESET="\033[0m"

# === ASCII ART BANNER ===
banner() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║        Welcome to WCPM v0.7           ║"
    echo "║    World Compute Package Manager      ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# === INSTALL FUNCTION ===
install_package() {
    local pkg="$1"
    local url="$BASE_URL/$pkg.sh"
    local script="$TMP_DIR/$pkg.sh"

    echo -e "${BLUE}📥 Downloading installer for: ${YELLOW}$pkg${RESET}"
    if ! curl -fsSL "$url" -o "$script"; then
        echo -e "${RED}❌ Failed to download installer: $pkg${RESET}"
        return 1
    fi

    echo -e "${GREEN}⚙️  Running installer...${RESET}"
    chmod +x "$script"
    bash "$script"
}

# === UNINSTALL FUNCTION ===
uninstall_package() {
    local pkg="$1"
    local url="$UNINSTALL_URL/$pkg.sh"
    local script="$TMP_DIR/uninstall-$pkg.sh"

    echo -e "${BLUE}📥 Downloading uninstaller for: ${YELLOW}$pkg${RESET}"
    if ! curl -fsSL "$url" -o "$script"; then
        echo -e "${RED}❌ Failed to download uninstaller: $pkg${RESET}"
        return 1
    fi

    echo -e "${YELLOW}⚙️  Running uninstaller...${RESET}"
    chmod +x "$script"
    bash "$script"
}

# === HELP / USAGE ===
usage() {
    echo -e "${YELLOW}Usage:${RESET} $0 {install|uninstall} <pkg1> [pkg2] ..."
    echo -e "Version: ${GREEN}0.6${RESET}"
    echo -e "Made by ${BLUE}n0b0dy-arch-btw${RESET}"
    echo ""
    exit 1
}

# === MAIN ENTRY POINT ===
clear
banner

action="$1"
shift

if [[ -z "$action" || $# -eq 0 ]]; then
    echo -e "${RED}❌ Error: No command or package name(s) provided.${RESET}"
    usage
fi

case "$action" in
    install)
        for pkg in "$@"; do
            install_package "$pkg"
        done
        ;;
    uninstall)
        for pkg in "$@"; do
            uninstall_package "$pkg"
        done
        ;;
    *)
        echo -e "${RED}❌ Invalid command: '$action'${RESET}"
        usage
        ;;
esac

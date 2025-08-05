#!/bin/bash

set -e

# === METADATA ===
PKG_NAME="htop"
DESCRIPTION="Interactive process viewer — see CPU, RAM and system processes."
AUTHOR="n0b0dy-arch-btw"
REPO_URL="https://github.com/htop-dev/htop.git"

# === COLORS ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
RESET="\033[0m"

# === ASCII HEADER ===
banner() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║         Installing Package: htop      ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
}

# === Spinner ===
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
    echo -ne "${YELLOW}[*] Verifying system and tools...${RESET}"
    sleep 3 &
    spinner
}

countdown() {
    echo -e "${BLUE}[*] Finishing installation...${RESET}"
    for i in {5..1}; do
        printf "\r    %2d seconds remaining..." "$i"
        sleep 1
    done
    echo -e "\r    ${GREEN}Install complete!           ${RESET}"
}

# === Start ===
clear
banner

# === Show Package Info ===
echo -e "${BLUE}📦 Package:${RESET}      $PKG_NAME"
echo -e "${BLUE}📝 Description:${RESET}  $DESCRIPTION"
echo -e "${BLUE}👤 Maintainer:${RESET}   GitHub @$AUTHOR"
echo ""

# === Confirm Install ===
read -p "❓ Do you want to install '$PKG_NAME'? [y/N]: " confirm
confirm="${confirm,,}"
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo -e "${RED}🚫 Installation canceled.${RESET}"
    exit 1
fi

verify_install

# === Take file snapshot BEFORE install ===
LOG_DIR="/var/lib/wcpm/packages"
LOG_FILE="$LOG_DIR/$PKG_NAME.list"
SNAP_BEFORE="/tmp/wcpm-before.txt"
SNAP_AFTER="/tmp/wcpm-after.txt"

sudo mkdir -p "$LOG_DIR"
sudo find /usr/local -type f > "$SNAP_BEFORE"

# === Installation Steps ===
STEP_1="git clone https://github.com/htop-dev/htop.git"
STEP_2="cd htop"
STEP_3="./autogen.sh"
STEP_4="./configure"
STEP_5="make"
STEP_6="sudo make install"
STEP_7=""
STEP_8=""
STEP_9=""
STEP_10=""

echo ""
for i in {1..10}; do
    step_var="STEP_$i"
    cmd="${!step_var}"
    if [[ -n "$cmd" ]]; then
        echo -e "${YELLOW}▶️ Step $i:${RESET} $cmd"
        if ! eval "$cmd"; then
            echo -e "${RED}❌ Step $i failed. Exiting.${RESET}"
            exit 1
        fi
    fi
done

# === Take snapshot AFTER install and track changes ===
sudo find /usr/local -type f > "$SNAP_AFTER"
comm -13 <(sort "$SNAP_BEFORE") <(sort "$SNAP_AFTER") > "/tmp/wcpm-diff.txt"
sudo mv "/tmp/wcpm-diff.txt" "$LOG_FILE"

countdown

echo -e "\n${GREEN}[✔] '$PKG_NAME' installed successfully!${RESET}\n"
echo -e "${YELLOW}[*] Installed files tracked at:${RESET} $LOG_FILE"

#!/bin/bash

# === CONFIGURATION ===
BASE_URL="https://dev.world-compute.com/packages"  # your GitHub Pages URL
TMP_DIR="/tmp/wcpm"                              # temporary download dir
mkdir -p "$TMP_DIR"

# === INSTALL FUNCTION ===
install_package() {
    local pkg="$1"
    local url="$BASE_URL/$pkg.sh"
    local script="$TMP_DIR/$pkg.sh"

    echo "📥 Downloading: $url"
    if ! curl -fsSL "$url" -o "$script"; then
        echo "❌ Failed to download $pkg"
        return 1
    fi

    echo "⚙️ Installing: $pkg"
    chmod +x "$script"
    bash "$script"
}

# === USAGE ===
usage() {
    echo "Usage: $0 install <pkg1> [pkg2] ..."
    echo "Version 0.5"
    echo "package manager made by n0b0dy-arch-btw"
    echo "welcome to wcpm"
    exit 1
}

# === MAIN ENTRY POINT ===
if [[ "$1" == "install" ]]; then
    shift
    if [[ $# -eq 0 ]]; then
        echo "❌ No package name provided."
        usage
    fi

    for pkg in "$@"; do
        install_package "$pkg"
    done
else
    usage
fi

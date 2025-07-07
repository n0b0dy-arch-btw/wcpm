#!/bin/bash

# === PACKAGE METADATA ===
PKG_NAME="neofetch"
DESCRIPTION="A command-line system information tool"
AUTHOR="n0b0dy-arch-btw"

# === DISPLAY PACKAGE INFO ===
echo ""
echo "📦 Package:       $PKG_NAME"
echo "📝 Description:   $DESCRIPTION"
echo "👤 Maintainer:    GitHub user @$AUTHOR"
echo ""

# === CONFIRM INSTALLATION ===
read -p "❓ Are you sure you want to install '$PKG_NAME'? [y/N]: " confirm
confirm="${confirm,,}"  # to lowercase
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
  echo "🚫 Canceled installation of '$PKG_NAME'."
  exit 0
fi

# === INSTALLATION STEPS ===
# Each one is optional: if left empty, it will be skipped.
STEP_1="git clone https://github.com/dylanaraps/neofetch"
STEP_2="cd neofetch"
STEP_3="sudo make install"
STEP_4=""
STEP_5=""
STEP_6=""
STEP_7=""
STEP_8=""
STEP_9=""
STEP_10=""

# === EXECUTE STEPS ===
for i in {1..10}; do
  step_var="STEP_$i"
  cmd="${!step_var}"
  if [[ -n "$cmd" ]]; then
    echo "▶️ Step $i: $cmd"
    if ! eval "$cmd"; then
      echo "❌ Step $i failed: $cmd"
      exit 1
    fi
  fi
done

echo "✅ All steps for '$PKG_NAME' completed!"

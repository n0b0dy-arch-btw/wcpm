#!/bin/bash

# === PACKAGE METADATA ===
PKG_NAME="cmatrix"
DESCRIPTION="shows text flying in and out in a terminal like as seen in The Matrix movie"
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
STEP_1="git clone https://github.com/abishekvashok/cmatrix.git"
STEP_2="cd cmatrix"
STEP_3="autoreconf -i"
STEP_4="./configure"
STEP_5="make"
STEP_6="sudo make install"
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

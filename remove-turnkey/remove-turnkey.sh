#!/bin/bash

# === REMOVE TURNKEY SETUP ===
# Reverts changes made by turnkey.sh for a clean reset.

echo "⚠️  This script will remove files and settings created by turnkey.sh."
echo "Do you want to continue? (y/n)"
read -r confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

ZSHRC="$HOME/.zshrc"
ZPROFILE="$HOME/.zprofile"

### 1. Skipping SSH removal (preserving GitHub SSH access) ###
echo "🔒 Skipping SSH key and GitHub config removal."

### 2. Uninstall Homebrew ###
echo "🧽 Uninstalling Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

### 3. Remove Homebrew PATH logic from .zshrc and .zprofile ###
if grep -q 'brew shellenv' "$ZSHRC"; then
  sed -i '' '/brew shellenv/d' "$ZSHRC"
  echo "🧹 Removed Homebrew path from ~/.zshrc"
fi

if [ -f "$ZPROFILE" ] && grep -q 'brew shellenv' "$ZPROFILE"; then
  sed -i '' '/brew shellenv/d' "$ZPROFILE"
  echo "🧹 Removed Homebrew path from ~/.zprofile"
fi

### 4. Remove NVM auto-switch logic ###
if grep -q '👉 Using Node version' "$ZSHRC"; then
  sed -i '' '/# Auto-load .nvmrc Node version/,/load-nvmrc/d' "$ZSHRC"
  echo "🧹 Removed .nvmrc auto-switch hook from ~/.zshrc"
fi

### 5. Remove alias: c. ###
if grep -q 'alias c.=' "$ZSHRC"; then
  sed -i '' '/alias c.=/d' "$ZSHRC"
  echo "🧹 Removed alias: c."
fi

### 6. Remove alias: gclone ###
if grep -q 'alias gclone=' "$ZSHRC"; then
  sed -i '' '/alias gclone=/,/unset -f f/d' "$ZSHRC"
  echo "🧹 Removed alias: gclone"
fi

### 7. Final message ###
echo "✅ Turnkey additions removed. You may need to restart your terminal to apply changes."
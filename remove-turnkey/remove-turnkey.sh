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

### 1. Skipping SSH removal (preserving GitHub SSH access) ###
echo "🔒 Skipping SSH key and GitHub config removal."

### 2. Remove Homebrew ###
echo "🧽 Uninstalling Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

### 3. Remove Homebrew PATH logic from ~/.zshrc and ~/.zprofile ###
if grep -q 'brew shellenv' ~/.zshrc; then
  sed -i '' '/brew shellenv/d' ~/.zshrc
  echo "🧹 Removed Homebrew path from ~/.zshrc"
fi

if grep -q 'brew shellenv' ~/.zprofile; then
  sed -i '' '/brew shellenv/d' ~/.zprofile
  echo "🧹 Removed Homebrew path from ~/.zprofile"
fi

### 4. Done ###
echo "✅ Turnkey setup has been removed."


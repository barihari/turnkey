#!/bin/bash

# === TURNKEY DEV SETUP ===
# Minimal setup for a new Mac with Git, SSH, and Homebrew.

echo "⚠️  This script will install tools and configure GitHub SSH access."
echo "Do you want to continue? (y/n)"
read -r confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

### 1. Xcode CLI Tools ###
if ! xcode-select -p &>/dev/null; then
  echo "🔧 Installing Xcode CLI tools..."
  xcode-select --install
else
  echo "✅ Xcode CLI tools already installed."
fi

### 2. Homebrew ###
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon (in ~/.zshrc)
  if ! grep -q 'brew shellenv' ~/.zshrc; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    echo "✅ Added Homebrew path to ~/.zshrc"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed."
fi

### 3. Git Check ###
if ! command -v git &>/dev/null; then
  echo "❌ Git not found. Please ensure Xcode CLI tools were installed correctly."
  exit 1
else
  echo "✅ Git is available."
fi

### 4. SSH Key Setup for GitHub ###
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "🔐 No SSH key found. Let's create one."
  read -rp "Enter your GitHub email address: " github_email

  ssh-keygen -t ed25519 -C "$github_email"
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519

  # Write GitHub-specific SSH config
  cat <<EOF > ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
  UseKeychain yes
EOF

  echo "📋 SSH key generated and copied to clipboard:"
  pbcopy < ~/.ssh/id_ed25519.pub
  cat ~/.ssh/id_ed25519.pub

  echo "👉 Add it to GitHub: https://github.com/settings/ssh/new"
  echo "→ Paste the key"
  echo "→ Name it (e.g. 'MacBook Pro')"
  echo "→ Click [Add SSH key]"
  echo "👉 Press Enter once you've added the key to GitHub..."
  read -r
else
  echo "✅ SSH key already exists."
fi

# Test SSH connection
echo "🔌 Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH is working! You're connected to GitHub."
else
  while true; do
    echo "❌ SSH test failed. Make sure the key was added correctly."
    echo "👉️  Press Enter to try again, or type 'skip' to continue without testing:"
    read -r input
    if [[ "$input" == "skip" ]]; then
      echo "⏭️ Skipping SSH test. You can test later with:"
      echo "    ssh -T git@github.com"
      break
    fi

    echo "🔌 Retesting SSH connection to GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
      echo "✅ SSH is working! You're connected to GitHub."
      break
    fi
  done
fi

echo "🎉 Done! Your dev environment is ready."


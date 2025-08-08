#!/bin/bash

# === TURNKEY DEV SETUP ===

echo "⚠️  This script will install tools and make system changes on your Mac."
echo "Do you want to continue? (y/n)"
read -r confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

ZSHRC="$HOME/.zshrc"

### 1. Xcode CLI ###
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
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$ZSHRC"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed."
fi

### 3. Git ###
if ! command -v git &>/dev/null; then
  echo "❌ Git not found. Please ensure Xcode CLI tools installed correctly."
  exit 1
else
  echo "✅ Git is available."
fi

### 4. SSH Setup ###
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/id_ed25519 ]; then
  echo "🔐 No SSH key found. Let's create one."
  read -rp "👉 Enter your GitHub email address: " github_email
  ssh-keygen -t ed25519 -C "$github_email"
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519

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
  echo "👉 Press Enter once you've added the key to GitHub..."
  read -r
else
  echo "✅ SSH key already exists."
fi

echo "🔌 Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  echo "✅ SSH is working!"
else
  while true; do
    echo "❌ SSH test failed."
    echo "👉 Press Enter to try again, or type 'skip' to continue:"
    read -r input
    if [[ "$input" == "skip" ]]; then
      echo "⏭️ Skipping SSH test. Run manually later with: ssh -T git@github.com"
      break
    fi
    echo "🔌 Retesting SSH..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
      echo "✅ SSH is working!"
      break
    fi
  done
fi

### 5. Install NVM ###
if [ ! -d "$HOME/.nvm" ]; then
  echo "⬇️ Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  echo 'export NVM_DIR="$HOME/.nvm"' >> "$ZSHRC"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$ZSHRC"
  echo "✅ NVM installed and configured in .zshrc"
else
  echo "✅ NVM already installed."
fi

### 6. Auto-load `.nvmrc` with log ###
if ! grep -q "👉 Using Node version" "$ZSHRC"; then
  cat <<'EOF' >> "$ZSHRC"

# Auto-load .nvmrc Node version on directory change (with log)
autoload -U add-zsh-hook

load-nvmrc() {
  if nvm --version &>/dev/null && [ -f .nvmrc ]; then
    local node_version
    node_version=$(<.nvmrc)
    echo "👉 Using Node version ${node_version} from .nvmrc"
    nvm use &> /dev/null
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
EOF
  echo "✅ Added .nvmrc auto-switch hook with log to .zshrc"
fi

### 7. Reusable Aliases ###

# c. — open current directory in Cursor
if ! grep -q "alias c\." "$ZSHRC"; then
  echo 'alias c.='\''open -a "Cursor" .'\''' >> "$ZSHRC"
  echo "✅ Added alias: c."
fi

# gclone — git clone full SSH URL + cd + open Cursor
if ! grep -q "alias gclone=" "$ZSHRC"; then
  cat <<'EOF' >> "$ZSHRC"

alias gclone='f() { git clone "$1" && cd "$(basename "$1" .git)" && open -a "Cursor" .; unset -f f; }; f'
EOF
  echo "✅ Updated alias: gclone to support full SSH URLs"
fi

### 8. Final Message (no sourcing)
echo "🎉 Done! Your dev environment is set up."
echo "👉 Restart your terminal or open a new tab, or run: source ~/.zshrc to activate changes."


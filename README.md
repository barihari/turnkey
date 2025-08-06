# Turnkey Dev Environment Setup

This repo contains two scripts for managing a lightweight development environment setup on a new Mac.

---

## 🔑 `turnkey.sh`

**Purpose**: Sets up a clean, minimal local dev environment using the following steps:

### What It Does:

* Installs Xcode Command Line Tools
* Installs Homebrew and adds it to your `~/.zshrc`
* Verifies Git is available
* Generates an SSH key and sets up GitHub access:

  * Prompts for GitHub email
  * Copies public key to clipboard
  * Guides you to GitHub key settings page
* Tests SSH authentication to GitHub (with retry option)

### Usage

1. Make it executable:

   ```bash
   chmod +x turnkey.sh
   ```

2. Run it:

   ```bash
   ./turnkey.sh
   ```

---

## 🧽 `remove-turnkey.sh`

**Purpose**: Reverts what `turnkey.sh` set up, without touching your personal GitHub SSH configuration.

### What It Does:

* Uninstalls Homebrew
* Removes Homebrew path logic from:

  * `~/.zshrc`
  * `~/.zprofile`
* Skips SSH key removal (leaves GitHub SSH config untouched)

### What It Does *Not* Do:

* Does not remove your `~/.ssh` folder or SSH keys
* Does not remove Git or Xcode CLI tools
* Does not remove shell themes, aliases, or project folders

### Usage

1. Make it executable:

   ```bash
   chmod +x remove-turnkey.sh
   ```

2. Run it:

   ```bash
   ./remove-turnkey.sh
   ```

---

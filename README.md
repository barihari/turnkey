# Turnkey Dev Environment Setup

This repo contains two scripts for managing a development environment setup on a Mac.

---

## 🔑 `turnkey.sh`

**Purpose**: Sets up a custom, local dev environment using the following steps:

### What It Does:

* Installs Xcode Command Line Tools
* Installs Homebrew and adds it to `~/.zshrc`
* Verifies Git is available
* Generates an SSH key and sets up GitHub access:
  * Prompts for GitHub email
  * Copies public key to clipboard
  * Guides to GitHub key settings page
  * Tests SSH authentication to GitHub
* Installs NVM (Node Version Manager)
* Adds automatic `.nvmrc` detection to the shell:
  * Runs `nvm use` automatically when `.nvmrc` is present
  * Prints a message like: `👉 Using Node version 18 from .nvmrc`
* Adds two reusable aliases to the shell:
  * `c.` — opens the current directory in Cursor
  * `gclone` — clones a GitHub repo via SSH, CDs into it, and opens it in Cursor

### Usage

In the directory containing the script:

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

**Purpose**: Reverts what `turnkey.sh` set up, without touching GitHub SSH configuration.

### What It Does:

* Uninstalls Homebrew
* Removes Homebrew path logic from:
  * `~/.zshrc`
  * `~/.zprofile`
* Removes .nvmrc auto-switch logic from `~/.zshrc`
* Removes all aliases added by turnkey.sh

### What It Does *Not* Do:

* Does not remove the `~/.ssh` folder or SSH keys
* Does not remove Git or Xcode CLI tools
* Preserves original .zshrc settings and customizations outside of turnkey.sh

### Usage

In the directory containing the script (e.g., `/turnkey/remove-turnkey/`):

1. Make it executable:

   ```bash
   chmod +x remove-turnkey.sh
   ```

2. Run it:

   ```bash
   ./remove-turnkey.sh
   ```

---

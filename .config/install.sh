#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "========================================="
echo "  Starting System Restoration Process  "
echo "========================================="

# 1. Install prerequisites
echo "==> Ensuring git and base-devel are installed..."
sudo pacman -Syu --needed git base-devel --noconfirm

# 2. Install yay (AUR Helper) if not installed
if ! command -v yay &>/dev/null; then
  echo "==> Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  rm -rf /tmp/yay
  cd "$HOME"
else
  echo "==> yay is already installed."
fi

# Define the config function locally for the script
function config {
  /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# 3. Checkout files safely
echo "==> Checking out files from repository..."
mkdir -p "$HOME/.dotfiles-backup"
if config checkout 2>&1 | grep -E "\s+\."; then
  echo "Backing up pre-existing dotfiles to ~/.dotfiles-backup..."
  config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} "$HOME/.dotfiles-backup/"
fi
config checkout -f

# 4. Configure repository settings and restore SSH push access
echo "==> Configuring repository settings..."
config config --local status.showUntrackedFiles no
config remote set-url origin git@github.com:RuiXavier/arch-setup.git
echo "==> Remote URL switched back to SSH for future pushes."

# 5. Install Official Packages
echo "==> Installing official Arch packages..."
if [ -f "$HOME/.config/pkglist/pacman-repo.txt" ]; then
  sudo pacman -S --needed - <"$HOME/.config/pkglist/pacman-repo.txt"
else
  echo "Official package list not found. Skipping."
fi

# 6. Install AUR Packages
echo "==> Installing AUR packages..."
if [ -f "$HOME/.config/pkglist/pacman-aur.txt" ]; then
  yay -S --needed - <"$HOME/.config/pkglist/pacman-aur.txt"
else
  echo "AUR package list not found. Skipping."
fi

# 7. Restore System-Level Configurations (SDDM)
echo "==> Restoring system configurations..."
if [ -d "$HOME/.config/system-backups/etc" ]; then
  echo "Copying /etc/ configurations..."
  sudo cp -rv "$HOME/.config/system-backups/etc/"* /etc/
else
  echo "No system backups found in ~/.config/system-backups/etc. Skipping."
fi

# 8. Set Zsh as default shell
echo "==> Setting Zsh as default shell..."
if [ "$SHELL" != "/usr/bin/zsh" ] && command -v zsh &>/dev/null; then
  chsh -s /usr/bin/zsh
fi

echo "========================================="
echo "  Restoration Complete! Reboot system. "
echo "========================================="

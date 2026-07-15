#!/bin/bash

echo "========================================="
echo "  Synchronizing Dotfiles to GitHub...  "
echo "========================================="

# 1. Update Package Lists
echo "==> Exporting current package lists..."
pacman -Qqen >~/.config/pkglist/pacman-repo.txt
yay -Qqem >~/.config/pkglist/pacman-aur.txt

# 2. Update System-Level Configurations
echo "==> Copying system files (/etc/)..."
# Create the backup directories if they don't exist
mkdir -p ~/.config/system-backups/etc/sddm.conf.d

# Copy pacman and SDDM configs (ignoring errors if they don't exist)
sudo cp /etc/pacman.conf ~/.config/system-backups/etc/ 2>/dev/null || true
sudo cp /etc/sddm.conf ~/.config/system-backups/etc/ 2>/dev/null || true
sudo cp -r /etc/sddm.conf.d/* ~/.config/system-backups/etc/sddm.conf.d/ 2>/dev/null || true
mkdir -p ~/.config/system-backups/usr/share/sddm/themes/
sudo cp -r /usr/share/sddm/themes/catppuccin-mocha-pink ~/.config/system-backups/usr/share/sddm/themes/ 2>/dev/null || true

# Fix permissions so Git (running as your user) can read the copied files
sudo chown -R $USER:$USER ~/.config/system-backups/

# 3. Define local Git command
function config {
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

# 4. Stage and Push Changes
echo "==> Staging files for Git..."
# Explicitly add your tracked directories in case you created brand new files inside them
config add .config/ Pictures/wallpapers/ 'Current Vibe'/ Avatar/ .face/ .zshrc .gitconfig .gtkrc-2.0 .zshenv

# Commit with a dynamic timestamp
TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
echo "==> Committing with message: Automated update: $TIMESTAMP"
config commit -m "Automated update: $TIMESTAMP" || echo "No changes to commit."

echo "==> Pushing to GitHub..."
config push -u origin main

echo "========================================="
echo "  Dotfiles successfully updated! "
echo "========================================="

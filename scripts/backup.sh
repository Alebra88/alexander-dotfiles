#!/bin/bash

# Package Backup Script
# Saves current system packages to text files

set -e

echo "📋 Backing up current packages..."

# Create packages directory if it doesn't exist
mkdir -p packages

# Backup official packages
echo "📦 Exporting official repository packages..."
pacman -Qqe > packages/official.txt
echo "  ✅ Saved $(wc -l < packages/official.txt) official packages"

# Backup AUR packages
echo "📦 Exporting AUR packages..."
pacman -Qqem > packages/aur.txt
echo "  ✅ Saved $(wc -l < packages/aur.txt) AUR packages"

echo ""
echo "✅ Package backup complete!"
echo ""
echo "Files created:"
echo "  • packages/official.txt ($(wc -l < packages/official.txt) packages)"
echo "  • packages/aur.txt ($(wc -l < packages/aur.txt) packages)"
echo ""
echo "To restore packages on a new system, run:"
echo "  sudo pacman -S \$(cat packages/official.txt)"
echo "  yay -S \$(cat packages/aur.txt)"
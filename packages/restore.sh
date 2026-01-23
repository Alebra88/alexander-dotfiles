#!/bin/bash

# Package Restoration Script
# Installs packages from saved lists

set -e

echo "🔄 Restoring packages from lists..."

# Check if packages directory exists
if [[ ! -d "packages" ]]; then
    echo "❌ Error: packages directory not found"
    echo "   Run ./scripts/backup.sh first to create package lists"
    exit 1
fi

# Install official packages
if [[ -f "packages/official.txt" ]] && [[ -s "packages/official.txt" ]]; then
    echo "📦 Installing official packages..."
    echo "  Found $(wc -l < packages/official.txt) packages to install"
    
    if command -v sudo &> /dev/null; then
        sudo pacman -S --needed $(cat packages/official.txt)
    else
        echo "❌ Error: sudo not available. Cannot install official packages."
        exit 1
    fi
else
    echo "⚠️  No official packages found or file is empty"
fi

# Install AUR packages (if yay is available)
if [[ -f "packages/aur.txt" ]] && [[ -s "packages/aur.txt" ]]; then
    echo "📦 Installing AUR packages..."
    echo "  Found $(wc -l < packages/aur.txt) AUR packages to install"
    
    if command -v yay &> /dev/null; then
        yay -S --needed $(cat packages/aur.txt)
    else
        echo "⚠️  Warning: Yay not found. AUR packages will be skipped."
        echo "   To install Yay:"
        echo "   sudo pacman -S --needed git base-devel"
        echo "   git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
    fi
else
    echo "⚠️  No AUR packages found or file is empty"
fi

echo ""
echo "✅ Package restoration complete!"
echo ""
echo "Next steps:"
echo "  • Run './scripts/install.sh' to set up dotfiles"
echo "  • Restart your shell to apply all changes"
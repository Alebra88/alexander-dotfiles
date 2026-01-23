#!/bin/bash

# Dotfiles Installation Script
# Sets up a complete system from scratch

set -e  # Exit on any error

echo "🚀 Starting dotfiles installation..."

# Check if running from dotfiles directory
if [[ ! -f "README.md" ]]; then
    echo "❌ Error: Please run this script from the dotfiles directory"
    exit 1
fi

# Install GNU Stow if not present
if ! command -v stow &> /dev/null; then
    echo "📦 Installing GNU Stow..."
    sudo pacman -S stow
fi

# Check for Yay (AUR helper)
if ! command -v yay &> /dev/null; then
    echo "⚠️  Warning: Yay not found. Installing AUR packages will be skipped."
    echo "   To install Yay manually:"
    echo "   sudo pacman -S --needed git base-devel"
    echo "   git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install official packages
if [[ -f "packages/official.txt" ]] && [[ -s "packages/official.txt" ]]; then
    echo "📦 Installing official packages..."
    sudo pacman -S --needed $(cat packages/official.txt)
else
    echo "⚠️  No official packages found or file is empty"
fi

# Install AUR packages (if yay is available)
if command -v yay &> /dev/null; then
    if [[ -f "packages/aur.txt" ]] && [[ -s "packages/aur.txt" ]]; then
        echo "📦 Installing AUR packages..."
        yay -S --needed $(cat packages/aur.txt)
    else
        echo "⚠️  No AUR packages found or file is empty"
    fi
fi

# Stow all dotfiles
echo "🔗 Setting up dotfiles with GNU Stow..."

# List of directories to stow (skip packages and scripts)
dirs=$(find . -maxdepth 1 -type d ! -name "." ! -name "packages" ! -name "scripts" ! -name ".git" -printf "%f\n")

for dir in $dirs; do
    if [[ -d "$dir" ]]; then
        echo "  📁 Stowing $dir..."
        stow "$dir"
    fi
done

echo "✅ Installation complete!"
echo ""
echo "🎉 Your system is now configured!"
echo ""
echo "Next steps:"
echo "  • Restart your shell to apply changes"
echo "  • Check that all applications work as expected"
echo "  • Customize any configurations as needed"
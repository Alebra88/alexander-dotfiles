# 🏠 Dotfiles Repository

A complete system configuration managed with GNU Stow for easy deployment across multiple machines.

## 📁 Repository Structure

```
dotfiles/
├── 📦 packages/          # Package lists for system restoration
│   ├── official.txt     # Official repository packages
│   ├── aur.txt          # AUR packages
│   └── restore.sh       # Package installation script
├── 📜 scripts/           # Setup and maintenance scripts
│   ├── install.sh       # One-command full system setup
│   └── backup.sh        # Backup current packages
├── 🔧 shells/           # Shell configurations
│   └── bash/            # Bash settings
├── 💻 terminals/        # Terminal emulator configs
│   ├── alacritty/
│   ├── kitty/
│   └── ghostty/
├── ✏️ editors/          # Text editor configurations
│   └── nvim/            # Neovim setup
├── 🖼️ window-manager/   # Window manager and desktop
│   ├── hypr/            # Hyprland settings
│   ├── waybar/          # Waybar configuration
│   └── walker/          # Application launcher
├── 🛠️ tools/            # Various tool configurations
│   ├── git/             # Git settings
│   ├── starship/        # Prompt customization
│   └── btop/            # System monitor
└── ⚙️ system/            # System-wide configurations
    └── mimeapps.list    # Default applications
```

## 🚀 Quick Start

### On a New Machine

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/dotfiles ~/dotfiles

# 2. Run the installation script
cd ~/dotfiles
chmod +x scripts/install.sh
./scripts/install.sh
```

That's it! Your entire system will be configured exactly like your current setup.

## 📋 What's Included

### ✅ Package Management
- **Official packages**: All installed from Arch repositories
- **AUR packages**: All installed from the Arch User Repository
- **Automatic restoration**: Scripts to reinstall everything on new systems

### ✅ Dotfiles Management
- **GNU Stow**: Symlink manager for clean file organization
- **Zero downtime**: All configurations work immediately
- **Easy updates**: Simply commit and push changes

### ✅ Complete System Replication
- **Shell environments**: Bash profiles and configurations
- **Terminal setups**: Alacritty, Kitty, Ghostty configurations
- **Window manager**: Hyprland, Waybar, Walker settings
- **Development tools**: Git, Neovim, and editor configurations
- **System settings**: Default applications, MIME types, and more

## 🔧 Manual Operations

### Install Specific Components
```bash
cd ~/dotfiles

# Install everything
stow .

# Install specific categories
stow shells terminals window-manager
stow editors tools system

# Remove symlinks
stow -D shells
```

### Update Package Lists
```bash
# Backup current packages
./scripts/backup.sh

# Install packages from lists
./packages/restore.sh
```

### Add New Configurations
```bash
# 1. Move config to appropriate folder
mv ~/.config/new-app ~/dotfiles/tools/new-app/.config/new-app

# 2. Stow the new configuration
cd ~/dotfiles && stow tools

# 3. Commit and push changes
git add .
git commit -m "Add new-app configuration"
git push
```

## 📖 How It Works

### GNU Stow Magic
Stow creates **symbolic links** from organized folders back to their original locations:

```
~/dotfiles/shells/bash/.bashrc  →  ~/.bashrc
~/dotfiles/tools/git/.gitconfig →  ~/.gitconfig
```

**Benefits:**
- ✅ Original files remain untouched
- ✅ Easy to track changes with Git
- ✅ Simple to enable/disable configurations
- ✅ Clean, organized repository structure

### Package Restoration
The package lists capture your exact system state:

```bash
# Official packages
sudo pacman -S $(cat packages/official.txt)

# AUR packages  
yay -S $(cat packages/aur.txt)
```

## 🔄 Maintenance

### Regular Updates
```bash
# Update dotfiles
cd ~/dotfiles && git pull && stow .

# Update package lists
./scripts/backup.sh && git add packages/ && git commit -m "Update packages"
```

### Clean Installation
```bash
# Remove all dotfiles
stow -D .

# Reinstall everything
./scripts/install.sh
```

## 🛡️ Safety Features

- **Non-destructive**: Only creates symlinks, never deletes original files
- **Rollback ready**: Easy to undo any changes
- **Version controlled**: Full Git history of all configurations
- **Tested**: Works across multiple fresh installations

## 📚 Requirements

- **Arch Linux** (or Arch-based distro)
- **GNU Stow**: `sudo pacman -S stow`
- **Yay** (for AUR packages): `sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork and adapt for your own use
- Submit issues or questions
- Suggest improvements

## 📄 License

MIT License - do whatever you want with it!

---

**Made with ❤️ for a perfectly reproducible Linux setup**
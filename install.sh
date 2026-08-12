#!/usr/bin/env bash

set -euo pipefail

echo "================================="
echo " Linux Setup"
echo "================================="

# ---------------------------------------
# Detect package manager
# ---------------------------------------

if command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
else
    echo "Unsupported package manager."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"

# ---------------------------------------
# Install base packages
# ---------------------------------------

echo "Installing packages..."

case "$PKG_MANAGER" in
    apt)
        sudo apt update
        sudo apt install -y \
            git \
            curl \
            wget \
            zsh \
            tmux \
            unzip \
            fontconfig \
            build-essential \
            procps \
            file
        ;;

    dnf)
        sudo dnf install -y \
            git \
            curl \
            wget \
            zsh \
            tmux \
            unzip \
            fontconfig \
            @development-tools \
            procps-ng \
            file
        ;;

    pacman)
        sudo pacman -Sy --needed --noconfirm \
            git \
            curl \
            wget \
            zsh \
            tmux \
            unzip \
            fontconfig \
            base-devel \
            procps-ng \
            file
        ;;
esac

# ---------------------------------------
# Oh My Zsh
# ---------------------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."

    RUNZSH=no \
    CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed."
fi

# ---------------------------------------
# Powerlevel10k
# ---------------------------------------

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k..."

    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$P10K_DIR"
else
    echo "Powerlevel10k already installed."
fi

# ---------------------------------------
# Zsh plugins
# ---------------------------------------

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."

    git clone \
        https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."

    git clone \
        https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ---------------------------------------
# MesloLGS Nerd Font (for Powerlevel10k)
# ---------------------------------------

FONT_DIR="$HOME/.local/share/fonts"
MESLO_MARKER="$FONT_DIR/MesloLGS NF Regular.ttf"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

if [ ! -f "$MESLO_MARKER" ]; then
    echo "Installing MesloLGS Nerd Font for Linux..."

    mkdir -p "$FONT_DIR"

    for face in Regular Bold Italic "Bold Italic"; do
        file="MesloLGS NF ${face}.ttf"
        curl -fsSL "$BASE_URL/${file// /%20}" -o "$FONT_DIR/$file"
    done

    fc-cache -f "$FONT_DIR"
else
    echo "MesloLGS Nerd Font already installed for Linux."
fi

# ---------------------------------------
# Homebrew
# ---------------------------------------

BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"

if ! command -v brew >/dev/null 2>&1 && [ ! -x "$BREW_BIN" ]; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

if [ -x "$BREW_BIN" ]; then
    eval "$("$BREW_BIN" shellenv)"
fi

# ---------------------------------------
# uv (Astral)
# ---------------------------------------

if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv already installed."
fi

# Ensure ~/.local/bin is available in this session (uv default install location)
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------
# Dotfiles
# ---------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing configs..."

if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
fi

ln -sf "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"
ln -sf "$SCRIPT_DIR/configs/.tmux.conf" "$HOME/.tmux.conf"

# ---------------------------------------
# Set Zsh as default shell
# ---------------------------------------

ZSH_PATH="$(command -v zsh)"

if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "Setting Zsh as your default shell..."
    chsh -s "$ZSH_PATH"
fi

echo
echo "================================="
echo " Installation complete!"
echo "================================="
echo
echo "1. On WSL/Windows: install MesloLGS NF (see README), then set it as your terminal font"
echo "2. Restart your terminal (or run: exec zsh)"
echo "3. Run: p10k configure"
echo

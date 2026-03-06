#!/usr/bin/env bash

set -e

echo "== Fedora Zsh Setup =="

# 1. Установка зависимостей
echo "Installing packages..."
sudo dnf upgrade --refresh -y
sudo dnf install -y zsh git curl util-linux-user

# 2. Установка Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Установка плагина autosuggestions
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# 4. Копирование .zshrc
if [ -f ".zshrc" ]; then
    echo "Applying changes to .zshrc..."
    cp .zshrc "$HOME/.zshrc"
fi

# 5. Сделать zsh shell по умолчанию
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing shell to zsh..."
    chsh -s $(which zsh)
fi

echo "Done! Restart your terminal or run:"
echo "exec zsh"
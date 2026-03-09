#!/usr/bin/env bash

set -e

echo "== Fedora Zsh Setup =="

# 1. Установка зависимостей
echo "Select your distribution:"


PS3="Enter number: "

select distro in "Fedora" "Ubuntu/Mint" "Quit"; do
    case $distro in
        Fedora)
            PKG_UPDATE="sudo dnf upgrade --refresh -y"
            PKG_INSTALL="sudo dnf install -y zsh git curl util-linux-user fzf"
            break
            ;;
        Ubuntu/Mint)
            PKG_UPDATE="sudo apt update && sudo apt upgrade -y"
            PKG_INSTALL="sudo apt install -y zsh git curl util-linux-user fzf"
            break
            ;;
        Quit)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

# 2. Установка Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. zsh-autosuggestions
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
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
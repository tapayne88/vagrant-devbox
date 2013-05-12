#!/bin/bash

VAGRANT_HOME=/home/vagrant

function installZsh {
    echo "Installing Zsh..."
    sudo apt-get -y install zsh
    chsh -s /bin/zsh vagrant

    echo "Installing Oh-My-Zsh..."
    sudo apt-get -y install curl
    if [ ! -d "$VAGRANT_HOME/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git "$VAGRANT_HOME/.oh-my-zsh"
    fi
}

function linkConfigurationFiles {
    echo "Configuring Zsh..."
    if [ ! -L "$VAGRANT_HOME/.zshrc" ]; then
        ln -s "$VAGRANT_HOME/git/dotfiles/zsh/zshrc_server" "$VAGRANT_HOME/.zshrc"
    fi
    if [ ! -L "$VAGRANT_HOME/.oh-my-zsh/themes/tpayne-simple.zsh-theme" ]; then
        ln -s "$VAGRANT_HOME/git/dotfiles/zsh/themes/tpayne-simple.zsh-theme" "$VAGRANT_HOME/.oh-my-zsh/themes/"
    fi

    echo "Configuring git..."
    if [ ! -L "$VAGRANT_HOME/.gitconfig" ]; then
        ln -s "$VAGRANT_HOME/git/dotfiles/gitconfig" "$VAGRANT_HOME/.gitconfig"
    fi

    echo "Configuring vim..."
    if [ ! -L "$VAGRANT_HOME/.vimrc" ]; then
        mkdir -p "$VAGRANT_HOME/.vim/backups"
        mkdir -p "$VAGRANT_HOME/.vim/swaps"
        mkdir -p "$VAGRANT_HOME/.vim/undo"
        ln -s "$VAGRANT_HOME/git/dotfiles/vim/vimrc_server" "$VAGRANT_HOME/.vimrc"
    fi

    if [ ! -L "$VAGRANT_HOME/.editrc" ]; then
        ln -s "$VAGRANT_HOME/git/dotfiles/editrc" "$VAGRANT_HOME/.editrc"
    fi
    if [ ! -L "$VAGRANT_HOME/.inputrc" ]; then
        ln -s "$VAGRANT_HOME/git/dotfiles/inputrc" "$VAGRANT_HOME/.inputrc"
    fi
}

sudo apt-get update

sudo apt-get -y install build-essential git vim
installZsh
linkConfigurationFiles

sudo apt-mark hold grub-pc
sudo apt-get -y dist-upgrade
sudo apt-mark unhold grub-pc

echo ""
echo "Now, we need to upgrade grub-pc and rebuild some virtual box setting"
echo "but it will require some interaction from you! Follow the steps below:"
echo "   - \`vagrant ssh\`"
echo "   - \`sudo apt-get upgrade\`"
echo "   - close ssh connection"
echo "   - \`vagrant reload\` on local machine"
echo "   - \`vagrant ssh\` on local machine"
echo "   - \`sudo /etc/init.d/vboxadd setup\`"
echo "   - close ssh connection"
echo "   - \`vagrant reload\` on local machine"


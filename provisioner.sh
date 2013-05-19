#!/bin/bash

VAGRANT_HOME=/home/vagrant

function configureZsh {
    chsh -s /bin/zsh vagrant

    echo "Installing Oh-My-Zsh..."
    if [ ! -d "$VAGRANT_HOME/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git "$VAGRANT_HOME/.oh-my-zsh"
    fi

    if [ ! -L "$VAGRANT_HOME/.zshrc" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/zsh/zshrc_server" "$VAGRANT_HOME/.zshrc"
    fi

    if [ ! -L "$VAGRANT_HOME/.oh-my-zsh/themes/tpayne-vm-simple.zsh-theme" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/zsh/themes/tpayne-vm-simple.zsh-theme" "$VAGRANT_HOME/.oh-my-zsh/themes/"
    fi
    if [ ! -L "$VAGRANT_HOME/.oh-my-zsh/plugins/tpayne-vi-mode" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/zsh/plugins/tpayne-vi-mode" "$VAGRANT_HOME/.oh-my-zsh/plugins/"
    fi
}

function configureSymlinks {
    echo "Configuring git..."
    if [ ! -L "$VAGRANT_HOME/.gitconfig" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/gitconfig" "$VAGRANT_HOME/.gitconfig"
    fi

    echo "Configuring vim..."
    if [ ! -L "$VAGRANT_HOME/.vimrc" ]; then
        mkdir -p "$VAGRANT_HOME/.vim/backups"
        mkdir -p "$VAGRANT_HOME/.vim/swaps"
        mkdir -p "$VAGRANT_HOME/.vim/undo"
        ln -s "$VAGRANT_HOME/host_git/dotfiles/vim/vimrc_server" "$VAGRANT_HOME/.vimrc"
    fi

    if [ ! -L "$VAGRANT_HOME/.editrc" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/editrc" "$VAGRANT_HOME/.editrc"
    fi
    if [ ! -L "$VAGRANT_HOME/.inputrc" ]; then
        ln -s "$VAGRANT_HOME/host_git/dotfiles/inputrc" "$VAGRANT_HOME/.inputrc"
    fi
}

function configureDirectories {
    mkdir "$VAGRANT_HOME/git"
    sudo chown vagrant:vagrant "$VAGRANT_HOME/git"
}

function installPython {
    PYTHON_VERSION=`python -V 2>&1`
    if [ "$PYTHON_VERSION" != "Python 2.7.5" ]; then
        . "/vagrant/pythoninstaller.sh"
    fi
}

sudo apt-get update

sudo apt-get -y install build-essential git vim htop zsh curl
sudo apt-get -y dist-upgrade
configureZsh
configureSymlinks
configureDirectories

# Install python
installPython

echo ""
echo "Now run \`vagrant ssh\`"

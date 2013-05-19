#!/bin/bash

VAGRANT_HOME=/home/vagrant

function setOwnerVagrant {
    sudo chown -h vagrant:vagrant $1
}

function setupSymLink {
    if [ ! -L $2 ]; then
        ln -s $1 $2
        setOwnerVagrant $2
    fi
}

function configureZsh {
    echo "Configuring Zsh..."
    chsh -s /bin/zsh vagrant

    if [ ! -d "$VAGRANT_HOME/.oh-my-zsh" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git "$VAGRANT_HOME/.oh-my-zsh"
        setOwnerVagrant "$VAGRANT_HOME/.oh-my-zsh"
    fi

    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/zsh/zshrc_server" "$VAGRANT_HOME/.zshrc"
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/zsh/themes/tpayne-vm-simple.zsh-theme" "$VAGRANT_HOME/.oh-my-zsh/themes/tpayne-vm-simple.zsh-theme"
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/zsh/plugins/tpayne-vi-mode" "$VAGRANT_HOME/.oh-my-zsh/plugins/tpayne-vi-mode"
}

function configureSymlinks {
    echo "Configuring symlinks..."
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/gitconfig" "$VAGRANT_HOME/.gitconfig"
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/vim/vimrc_server" "$VAGRANT_HOME/.vimrc"
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/editrc" "$VAGRANT_HOME/.editrc"
    setupSymLink "$VAGRANT_HOME/host_git/dotfiles/inputrc" "$VAGRANT_HOME/.inputrc"
}

function configureDirectories {
    if [ ! -d "$VAGRANT_HOME/git" ]; then
        mkdir "$VAGRANT_HOME/git"
        setOwnerVagrant "$VAGRANT_HOME/git"
        setupSymLink "/vagrant/repos.txt" "$VAGRANT_HOME/git/repos.txt"
    fi
}

function installPython {
    PYTHON_VERSION=`python -V 2>&1`
    if [ "$PYTHON_VERSION" != "Python 2.7.5" ]; then
        . "/vagrant/pythoninstaller.sh"
    fi
}

sudo apt-get update

sudo apt-get -y install build-essential git vim htop zsh curl scons
sudo apt-get -y dist-upgrade
configureZsh
configureSymlinks
configureDirectories

# Install python
installPython

echo ""
echo "Now run \`vagrant ssh\`"

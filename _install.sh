#!/bin/bash

echoerr() { echo "$@" 1>&2; }

# Upgrade system
echoerr "Updating Linux..."
sudo apt-get update && sudo apt-get upgrade -y 

# VIM
echoerr "Installing VIM..."
sudo apt-get install vim-nox python3-pip -y \
    && pip3 install neovim

# TMUX

# Go
echoerr "Installing Go..."
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt-get update
sudo apt-get install golang-go -y

# Oh My Zsh
echoerr "Installing Oh My Zsh..."
if [ ! -d $HOME/.oh-my-zsh ]; then
    sudo apt-get install zsh -y \
        && chsh -s /usr/bin/zsh \
        && /bin/sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 
fi

# Oh My Zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Oh My Zsh Themes
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
cp -U ./p10k.zsh $HOME/.p10k.zsh

# kubectl
echoerr "Installing kubectl..."
if [ ! -x /usr/local/bin/kubectl ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
        && chmod +x ./kubectl \
        && sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Dotfiles 
echoerr "Fetching dotfiles..."
if [ ! -d $HOME/dotfiles ]; then
    git clone -q https://github.com/aneshas/dotfiles.git ~/dotfiles
fi
ln -sf $HOME/dotfiles/vimrc $HOME/.vimrc 
ln -sf $HOME/dotfiles/zshrc $HOME/.zshrc
# ln -sf $HOME/dotfiles/tmux.conf $HOME/.vimrc 

echoerr "Done."


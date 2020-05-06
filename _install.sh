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
echoerr "Installing Tmux..."
# TODO - Install latest version
sudo apt-get install tmux -y

# Go
echoerr "Installing Go..."
sudo add-apt-repository ppa:longsleep/golang-backports -y \
    && sudo apt-get update \
    && sudo apt-get install golang-go -y

# VSCode
echoerr "Installing Visual Studio Code..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ \
    && sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && sudo apt-get install apt-transport-https -y \
    && sudo apt-get update \
    && sudo apt-get install code -y

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
cp -u ./p10k.zsh $HOME/.p10k.zsh

# kubectl
echoerr "Installing kubectl..."
if [ ! -x /usr/local/bin/kubectl ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
        && chmod +x ./kubectl \
        && sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Gnome Tweak Tool
echoerr "Installing Gnome Tweak Tool..."
sudo add-apt-repository universe
sudo apt install gnome-tweak-tool

# Calibre
sudo apt-get install calibre -y

# .NET
echoerr "Installing .net core"
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install dotnet-sdk-3.1 -y

# TLP
echoerr "Installing TLP..."
sudo add-apt-repository ppa:linrunner/tlp
sudo apt update
sudo apt install tlp 

# Postgres
echoerr "Installing PostgreSQL..."
sudo apt-get install postgresql-11 -y
sudo apt-get install pgcli -y

# nodejs
echoerr "Installing NodeJS..."
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs -y

# Dotfiles 
echoerr "Fetching dotfiles..."
if [ ! -d $HOME/dotfiles ]; then
    git clone -q https://github.com/aneshas/dotfiles.git ~/dotfiles
fi
ln -sf $HOME/dotfiles/vimrc $HOME/.vimrc 
ln -sf $HOME/dotfiles/zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/tmux.conf $HOME/.tmux.conf 

# Git
git config --global user.name "Anes Hasicic"
git config --global user.email me@anes.io 

echoerr "Done."


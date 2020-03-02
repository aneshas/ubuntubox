#!/bin/bash

# Run this after starting vim for the first time and running PlugInstall

sudo apt-get install build-essential cmake python3-dev -y \
    && cd ~/.vim/plugged/YouCompleteMe \
    && python3 install.py --clang-completer --go-completer

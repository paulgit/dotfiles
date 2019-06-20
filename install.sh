#!/bin/bash

# Get the current folder
CURRFOLDER=$(PWD)
BACKUPFOLDER=$HOME/.dotfile-backup
ZSHRC=.zshrc
OHMYZSH="$HOME/.oh-my-zsh"

# clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH

ln -s "$CURRFOLDER/oh-my-zsh/paulgit.zsh-theme" "$OHMYZSH/custom/themes/paulgit.zsh-theme"

# Create backup folder
mkdir -p "$BACKUPFOLDER"
cp "$HOME/$ZSHRC" "$BACKUPFOLDER"
rm "$HOME/$ZSHRC"

if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  ln -s "$CURRFOLDER/zshrc-macos" "$HOME/$ZSHRC"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # Linux
  ln -s "$CURRFOLDER/zshrc-linux" "$HOME/$ZSHRC"
fi

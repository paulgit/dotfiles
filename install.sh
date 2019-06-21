#!/bin/bash

# Get the current folder
INSTALLFOLDER=$PWD
BACKUPFOLDER=$HOME/.dotfiles-backup
SYSBINFOLDER="/usr/local/bin"
USRBINFOLDER="$HOME/bin"
MCCONFIGFOLDER="$HOME/.config/mc"
MCSKINSFOLDER="$HOME/.local/share/mc/skins"
OHMYZSH="$HOME/.oh-my-zsh"
ZSHRC=.zshrc
LINUXDOTFILES="tmux.conf nanorc"
MACDOTFILES="tmux.conf nanorc"
SYSBINFILES="dp"

if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  DOTFILES=$MACDOTFILES
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # Linux
  DOTFILES=$LINUXDOTFILES
fi

# clone oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH

# Create backup folder
mkdir -p "$BACKUPFOLDER"
cp "$HOME/$ZSHRC" "$BACKUPFOLDER"
rm "$HOME/$ZSHRC"

# Backup any files that we replace before we replace them
mkdir -p $BACKUPFOLDER
for FILE in $DOTFILES; do
	[ -e "$HOME/.$FILE" ] && cp "$HOME/.$FILE" "$BACKUPFOLDER" && rm "$HOME/.$FILE";
done;
unset FILE;

# Create the symbolic link to our files
for FILE in $DOTFILES; do
	[ -e "$INSTALLFOLDER/dotfiles/$FILE" ] && ln -s "$INSTALLFOLDER/$FILE" "$HOME/.$FILE";
done;
unset FILE;

# OS specific stuff
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  # .zshrc file symbolic link
  ln -s "$INSTALLFOLDER/dotfiles/zshrc-macos" "$HOME/$ZSHRC"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # Linux
  # .zshrc file symbolic link
  ln -s "$INSTALLFOLDER/dotfiles/zshrc-linux" "$HOME/$ZSHRC"

  # If the bin folder doesn't exist, the create it
  if [[ ! -d "$USRBINFOLDER" ]]; then
  	mkdir -p "$USRBINFOLDER"
  fi

  # update all the bin files
  cp -a "$INSTALLFOLDER/user-bin/." "$USRBINFOLDER"

  # Copy system wide fies to /usr/local/bin (if they don't already exist)
  for FILE in $SYSBINFILES; do
     [ ! -e "$SYSBINFOLDER/$FILE" ] && sudo cp "$INSTALLFOLDER/system-bin/$FILE" "$SYSBINFOLDER"
  done;
  unset FILE;
fi

# Midnight Commander
mkdir -p $MCCONFIGFOLDER &> /dev/null
mkdir -p $MCSKINSFOLDER &> /dev/null
[ -e "$MCCONFIGFOLDER/ini" ] && mv "$MCCONFIGFOLDER/ini" "$BACKUPFOLDER"
[ -e "$MCSKINSFOLDER/pgdark.ini" ] && cp "$MCSKINSFOLDER/pgdark.ini" "$BACKUPFOLDER" && rm "$MCSKINSFOLDER/pgdark.ini"

# If the MC ini file already exists then update the skin entry, else copy
# our file
if [ -f "$MCCONFIGFOLDER/ini" ]; then
	sed -i 's/skin=.*/skin=pgdark/' "$MCCONFIGFOLDER/ini"
else
	cp "$INSTALLFOLDER/dotfiles/mc/ini" "$MCCONFIGFOLDER/ini"
fi
cp "$INSTALLFOLDER/dotfiles/mc/pgdark.ini" "$MCSKINSFOLDER/pgdark.ini"

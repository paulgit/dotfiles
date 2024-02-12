#!/bin/bash

# Get the current folder
INSTALLFOLDER=$PWD
BACKUPFOLDER=$HOME/.dotfiles-backup
USRLOCALBINFOLDER="/usr/local/bin"
MCCONFIGFOLDER="$HOME/.config/mc"
MCSKINSFOLDER="$HOME/.local/share/mc/skins"
OHMYZSH="$HOME/.oh-my-zsh"
ZSHRC=.zshrc
LINUXDOTFILES="tmux.conf nanorc"
MACDOTFILES="tmux.conf nanorc"
LINUXUSRLOCALBINFILES="dp"
MACUSRLOCALBINFILES="dp it it.py"

if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
	DOTFILES=$MACDOTFILES
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then # Linux
	DOTFILES=$LINUXDOTFILES
fi

# clone oh-my-zsh, if the folder doesn't exist
if [[ ! -d "$OHMYZSH" ]]; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH
fi

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
	[ -e "$INSTALLFOLDER/dotfiles/$FILE" ] && ln -s "$INSTALLFOLDER/dotfiles/$FILE" "$HOME/.$FILE";
done;
unset FILE;

# OS specific stuff
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
	# .zshrc file symbolic link
	ln -s "$INSTALLFOLDER/dotfiles/zshrc-macos" "$HOME/$ZSHRC"
	USRLOCALBINFILES=$MACUSRLOCALBINFILES
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then # Linux
	# .zshrc file symbolic link
	ln -s "$INSTALLFOLDER/dotfiles/zshrc-linux" "$HOME/$ZSHRC"
	USRLOCALBINFILES=$LINUXUSRLOCALBINFILES
fi

# Copy system wide fies to /usr/local/bin (if they don't already exist)
for FILE in $USRLOCALBINFILES; do
	[ ! -e "$USRLOCALBINFOLDER/$FILE" ] && sudo cp "$INSTALLFOLDER/usr-local-bin/$FILE" "$USRLOCALBINFOLDER"
done;
unset FILE;

# Midnight Commander
mkdir -p $MCCONFIGFOLDER &> /dev/null
mkdir -p $MCSKINSFOLDER &> /dev/null
[ -e "$MCCONFIGFOLDER/ini" ] && mv "$MCCONFIGFOLDER/ini" "$BACKUPFOLDER"
[ -e "$MCSKINSFOLDER/pgdark.ini" ] && cp "$MCSKINSFOLDER/pgdark.ini" "$BACKUPFOLDER" && rm "$MCSKINSFOLDER/pgdark.ini"

# If the MC ini file already exists then update the skin entry, else copy our file
if [ -f "$MCCONFIGFOLDER/ini" ]; then
	sed -i 's/skin=.*/skin=pgdark/' "$MCCONFIGFOLDER/ini"
else
	cp "$INSTALLFOLDER/dotfiles/mc/ini" "$MCCONFIGFOLDER/ini"
fi
cp "$INSTALLFOLDER/dotfiles/mc/pgdark.ini" "$MCSKINSFOLDER/pgdark.ini"

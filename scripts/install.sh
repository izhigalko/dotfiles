#!/usr/bin/env bash

dotfiles_dir=$HOME/.dotfiles

test -d ${dotfiles_dir} || { echo "Directory $dotfiles_dir not found"; exit 1; }

cd ${dotfiles_dir};

git pull origin master;

function sync() {
	rsync --exclude ".git*" --exclude "install.sh" --exclude ".idea/" -avh --no-perms . ~;
    sleep 1;
    xrdb $HOME/.Xresources
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	sync;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
            sync;
    fi;
fi;

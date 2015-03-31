#!/usr/bin/env bash

dotfiles_dir=$HOME/.dotfiles

test -d ${dotfiles_dir} || { echo "Directory $dotfiles_dir not found"; exit 1; }

cd ${dotfiles_dir};

git pull origin master;

function sync() {
	rsync --exclude ".git/" --exclude "install.sh" -avh --no-perms . ~;
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
if [[ $REPLY =~ ^[Yy]$ ]]; then
		sync;
fi;
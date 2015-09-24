#!/usr/bin/env bash

dotfiles_dir=$HOME/.dotfiles

test -d ${dotfiles_dir} || { echo "Directory $dotfiles_dir not found"; exit 1; }

cd ${dotfiles_dir};

git pull origin master;

rsync --exclude ".git*" --exclude "install.sh" --exclude ".idea/" -avh --no-perms . ~;

exit 0

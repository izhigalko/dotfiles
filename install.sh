#!/usr/bin/env bash

dotfiles_dir=$HOME/.dotfiles

function usage()
{
    cat <<USAGE
install.sh all|console

    all     Install all configs
    console Install only console configuration

USAGE
    exit 0
}

test -d ${dotfiles_dir} || { echo "Directory $dotfiles_dir not found"; exit 1; }

cd ${dotfiles_dir};

git pull origin master;

function sync_all() {
	rsync --exclude ".git*" --exclude "install.sh" --exclude ".idea/" -avh --no-perms . ~;
}

function sync_console() {
	rsync --exclude ".git*" --exclude "install.sh" --exclude ".idea/" --exclude ".config" -avh --no-perms . ~;
}

case "$1" in

    all)
        sync_all;
    ;;
    console)
        sync_console
    ;;
    *)
        usage
    ;;

esac

exit 0

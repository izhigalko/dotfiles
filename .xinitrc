unagi &
/usr/bin/xscreensaver -no-splash &
[[ -f $HOME/.Xresources ]] && xrdb $HOME/.Xresources

exec awesome

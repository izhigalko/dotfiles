unagi &
/usr/bin/xscreensaver -no-splash &
[[ -f $HOME/.Xresources ]] && xrdb $HOME/.Xresources
setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle, grp_led:scroll'
[[ `which kbdd 2> /dev/null` ]] && kbdd
exec awesome

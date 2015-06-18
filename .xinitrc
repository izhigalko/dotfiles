# Keyboard layouts
setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle, grp_led:scroll'
# Applications
[[ `which xscreensaver 2> /dev/null` ]] && /usr/bin/xscreensaver -no-splash &
[[ `which kbdd 2> /dev/null` ]] && kbdd
# Apply configuration
[[ -f $HOME/.Xresources ]] && xrdb $HOME/.Xresources
exec openbox-session 

# Keyboard layouts
setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle, grp_led:scroll'
[[ -f $HOME/.Xresources ]] && xrdb $HOME/.Xresources
exec openbox-session 

setxkbmap -option "terminate:ctrl_alt_bksp"
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
autorandr --change
exec i3

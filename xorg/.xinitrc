xset r rate 250 50

# Env
export EDITOR="vim"
export BROWSER="firefox"
export QT_QPA_PLATFORMTHEME=gtk2
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx

# Daemons
eval "$(dbus-launch --sh-syntax --exit-with-session)"
compton &
mpd
dbus-launch --exit-with-session thunar --daemon &
fcitx

# Programs
redshift &
transmission-gtk -m &

# WM
exec ck-launch-session dbus-launch --exit-with-session awesome --no-argb

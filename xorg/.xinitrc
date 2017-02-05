xset r rate 250 50

# Env
export EDITOR="vim"
export BROWSER="firefox"
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus

# Daemons
compton &
mpd
dbus-launch --exit-with-session thunar --daemon &

# Programs
redshift &
transmission-gtk -m &

# WM
exec ck-launch-session dbus-launch --exit-with-session awesome --no-argb

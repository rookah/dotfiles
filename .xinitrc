xset r rate 250 50

# Env
export EDITOR="vim"
export BROWSER="firefox"
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
#export GTK_IM_MODULE_FILE=/usr/lib/gtk-3.0/3.0.0/immodules.cache

# Daemons
compton -b 
mpd
dbus-launch --exit-with-session thunar --daemon &

# Programs
redshift &
transmission-gtk -m &

# WM
exec ck-launch-session dbus-launch --exit-with-session awesome --no-argb

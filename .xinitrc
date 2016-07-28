xset r rate 250 50

# Env
export EDITOR="vim"
export BROWSER="firefox"

# Daemons
compton &
mpd
devmon 2>&1 > /dev/null &

# PROGRAMS
redshift &
transmission-gtk -m &

# WM
exec dbus-launch --exit-with-session awesome --no-argb

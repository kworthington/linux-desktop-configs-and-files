#!/bin/sh
## ~/.xinitrc for use with dwm

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

## start dmenu
dmenu &

## set the desktop background
[ -f ~/.fehbg ] && sh ~/.fehbg &
[ ! -f ~/.fehbg ] && feh --bg-scale ~/Downloads/dwm-bkgrnd.jpg

## run pulse audio
start-pulseaudio-x11 &

## in the top bar, show: the date/time, (local) IP, Memory Usage, CPU Temp, and Load Average info (updates every second):
while true
do
        LOCALTIME=$(date +"%A %Y-%m-%d %H:%M:%S ET")
        IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1) # can get confused if you use vmware
        MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
        TEMP="$(sensors -f | awk '/hyst/ {print $2}')"
        LOADAVG=$(uptime | sed 's/.*://; s/,//g')
        xsetroot -name "$LOCALTIME - $IP - $MEM - $TEMP -$LOADAVG"
        sleep 1s
done &

## start the screensaver
xscreensaver &

## start dwm
exec dwm

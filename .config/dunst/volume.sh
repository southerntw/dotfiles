#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "█ " $(($volume / 5)) | sed 's/[0-9]//g')
    #    icon_name="/usr/local/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg"
   icon_name="/home/southern/.config/dunst/icons/volume_up.png"

    # Send the notification
    dunstify -i "a" -r 2593 -u low  "$bar" 
    canberra-gtk-play -i audio-volume-change -d "changeVolume"
#    dunstify -i "$icon_name" -r 2953 -u normal 
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer -D pulse sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer -D pulse set Master 1+ toggle > /dev/null
	if is_mute ; then
	    dunstify -i audio-volume-muted -r 2593 -u normal "Sound Muted"
	else
	    send_notification
	fi
	;;
esac


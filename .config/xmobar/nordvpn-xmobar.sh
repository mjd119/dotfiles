#!/bin/sh
# Modified from /usr/share/polybar/scripts/vpn-nordvpn-status.sh file to use with xmobar (mjd119)

STATUS=$(nordvpn status | grep Status | tr -d ' ' | cut -d ':' -f2)

if [ "$STATUS" = "Connected" ]; then
    echo "$(nordvpn status | grep City | cut -d ':' -f2)"
else
    echo "no vpn"
fi

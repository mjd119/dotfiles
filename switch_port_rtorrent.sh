#!/bin/bash

port=$1
if [[ -n $port ]]; then
	sudo sed -i -e "s/network.port_range.set =.*/network.port_range.set = $port-$port/" /etc/rtorrent.conf
	echo "your port was changed to $port"
else
	echo "please specify a port"
	exit
fi

#TODO Add check to see if rtorrent is already running
if sudo -u rtorrent tmux send-keys -t rtorrent C-x "session.save=" Enter; then
	echo "rtorrent session saved"
else
	echo "rtorrent failed to save session"
	exit
fi	
	echo "restarting rtorrent"
	sudo systemctl stop rtorrent httpd && sudo systemctl start rtorrent httpd && echo "rtorrent restarted"

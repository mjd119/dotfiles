#!/bin/bash
# Proton VPN script to keep port forwarding open
while true ; do date ; natpmpc -a 1 0 udp 60 -g 10.2.0.1 && natpmpc -a 1 0 tcp 60 -g 10.2.0.1 | head -n20 > port.log || { echo -e "ERROR with natpmpc command \a" ; break ; } ; sleep 45 ; done

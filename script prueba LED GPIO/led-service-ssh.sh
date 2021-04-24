#!/bin/bash
#/home/pi/led-service-cups.sh


while true;
do
systemctl status ssh.service | head -3 | tail -1 | grep "(running)" > /dev/null

    if [ $? = 0 ];
    then
        python led-service-ssh-on.py > /dev/null
        echo "LED SSH on"
    else
        python led-service-ssh-off.py > /dev/null
        echo "LED SSH off"
    fi

done

#
#
#if system.os("$?") -> para true or false
#
# hacer prueba con booleano
#
#>>> True == 1
#True
#>>> False == 0
#True
#>>> True + (False / True)
#1.0


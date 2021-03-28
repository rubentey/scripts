#!/bin/bash

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

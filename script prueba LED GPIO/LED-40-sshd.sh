#!/bin/bash
# /etc/GPIO_LED_SH_PY/LED-40-sshd.sh

while true;
do
systemctl status sshd.service | head -3 | tail -1 | grep "(running)" > /dev/null
	if [ $? = 0 ];
    then
        python /etc/GPIO_LED_SH_PY/LED-40-sshd-on.py > /dev/null
        echo "LED 40 sshd on - .sh"
    else
        python /etc/GPIO_LED_SH_PY/LED-40-sshd-off.py > /dev/null
        echo "LED 40 sshd off - .sh"
    fi
sleep 0.1
done

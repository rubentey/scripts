#!/bin/python
# Pin: 40	Service: sshd

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(40,GPIO.OUT)

GPIO.output(40,1)
print ("LED sshd on - .py")
time.sleep(2)

GPIO.cleanup()

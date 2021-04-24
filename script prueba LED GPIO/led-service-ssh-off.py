#!/bin/python
#/home/pi/led-service-cups-off.py

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(40,GPIO.OUT)

GPIO.output(40,0)
print ("LED ssh off")
time.sleep(2)

GPIO.cleanup()

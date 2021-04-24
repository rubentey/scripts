#!/bin/python
#/home/pi/led-service-cups-on.py

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(40,GPIO.OUT)

GPIO.output(40,1)
print ("LED ssh on")
time.sleep(2)

GPIO.cleanup()

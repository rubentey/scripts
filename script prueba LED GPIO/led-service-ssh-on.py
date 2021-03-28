#!/bin/python

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(40,GPIO.OUT)

GPIO.output(40,0)
print ("LED off")
time.sleep(2)

GPIO.cleanup()

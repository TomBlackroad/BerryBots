#!/usr/bin/env python3

import serial
import time

ser = serial.Serial('/dev/ttyAMA0', 9600)
if not ser.is_open:
  ser.open()
ser.flush()
#ser.write(100)
time.sleep(2)
print("setup done")

try:
  while 1:
    print('sending data to Ardu')
    ser.write(b'9')
    print('response recived')
    response = ser.readline().decode('utf-8').rstrip()
    print(response)
    time.sleep(10)

except KeyboardInterrupt:
  print('out...')
  ser.close()

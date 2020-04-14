import serial, time
arduino = serial.Serial("/dev/ttyAMA0", 9600)
print("setup done")
time.sleep(2)
print("sleep done")
arduino.write(b'9')
print("write done")
arduino.close()

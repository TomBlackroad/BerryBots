# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import time
import cv2

# initialize the camera and grab a reference to the raw camera cap$
camera = PiCamera()
camera.resolution = (640, 480)
camera.framerate = 20
camera.rotation = 180
rawCapture = PiRGBArray(camera, size=(640, 480))

# allow the camera to warmup
time.sleep(0.1)


def save_frames():
  nSnap   = 0
  fileName    = "%s/%s_" %(".", "Frame")

  # capture frames from the camera
  for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True):
    # grab the raw NumPy array representing the image, then initialize the timestamp
    # and occupied/unoccupied text
    image = frame.array
    
    cv2.imshow('camera', image)
    
    key = cv2.waitKey(1) & 0xFF
    rawCapture.truncate(0)
    
    if key == ord('q'):
      break
    if key == ord(' '):
      print("Saving image ", nSnap)
      cv2.imwrite("%s%d.jpg"%(fileName, nSnap), image)
      nSnap += 1




def main():
  save_frames()
  
  print("Files saved")

if __name__ == "__main__":
  main()

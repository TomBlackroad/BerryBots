import cv2

cap = cv2.VideoCapture('/home/mbl/Documents/BerryBots/BenchmarkTests/output2.avi')

while True:
   ret, frame = cap.read()
   if ret==True:
      cv2.imshow('frame', frame)
      cv2.waitKey(0)
   else:
      break

# When everything done, release the video capture and video write objects
cap.release()
print("...done...\n\n")

# Closes all the frames
cv2.destroyAllWindows()

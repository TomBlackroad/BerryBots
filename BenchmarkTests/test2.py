import numpy as np
import cv2
import cv2.aruco as aruco
import sys, time, math


marker_size  = 8 #- [cm]


#--- Get the camera calibration path
calib_path  = "./"
camera_matrix   = np.loadtxt(calib_path+'cameraMatrix.txt', delimiter=',')
camera_distortion   = np.loadtxt(calib_path+'cameraDistortion.txt', delimiter=',')

#--- Define the aruco dictionary
aruco_dict  = aruco.getPredefinedDictionary(aruco.DICT_4X4_100)
parameters  = aruco.DetectorParameters_create()


#--- Capture the videocamera (this may also be a video or a picture)
cap = cv2.VideoCapture('/home/mbl/Documents/BerryBots/BenchmarkTests/output2.avi')

frame_width = int(cap.get(3))
frame_height = int(cap.get(4))

#-- Font for the text in the image
font = cv2.FONT_HERSHEY_PLAIN

codec = cv2.VideoWriter_fourcc('X','V','I','D')
out = cv2.VideoWriter('outputPoses.avi',codec, 30, (frame_width,frame_height),0)


while True:

    #-- Read the camera frame
    ret, frame = cap.read()

    if ret == True:

        #-- Convert in gray scale
        gray    = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) #-- remember, OpenCV stores color images in Blue, Green, Red

        #-- Find all the aruco markers in the image
        corners, ids, rejected = aruco.detectMarkers(image=gray, dictionary=aruco_dict, parameters=parameters,
                                  cameraMatrix=camera_matrix, distCoeff=camera_distortion)

        if ids is not None:

            print("cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc")
            rvecs, tvecs, obj = aruco.estimatePoseSingleMarkers(corners, marker_size, camera_matrix, camera_distortion)
            print(rvecs)
            print(tvecs)
            #-- Draw the detected marker and put a reference frame over it
            aruco.drawDetectedMarkers(gray, corners)
            print(len(rvecs))
            print(len(ids))
            for i in range(len(rvecs)):
                print(rvecs[i,0,:])
                print(tvecs[i,0,:])
                aruco.drawAxis(gray, camera_matrix, camera_distortion,rvecs[i,0,:], tvecs[i,0,:], 10)

        out.write(gray)

    # Break the loop
    else:
        break

# When everything done, release the video capture and video write objects
cap.release()
out.release()
print("...done...\n\n")

# Closes all the frames
cv2.destroyAllWindows() 

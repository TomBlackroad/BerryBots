#!/bin/bash


echo "Hello there!"
echo " "
echo " "
echo "Let's intall ROS-Comm Kinetic packages on Rasbian Jessie"
echo " "
echo "This script just works for ROS Kinetic on Rasbian Jessie..."
echo "Don't expect it to work otherwise"
echo " "
echo "Ctl-C to exit"
echo " "
echo "1.- Adding Released Packages"


cd ~/ros_catkin_ws

mv -i kinetic-custom_ros.rosinstall kinetic-custom_ros.rosinstall.old
echo " "
echo "Installing -> " $*
rosinstall_generator ros_comm $* --rosdistro kinetic --deps --wet-only --tar > kinetic-custom_ros.rosinstall

diff -u kinetic-custom_ros.rosinstall kinetic-custom_ros.rosinstall.old

wstool merge -t src kinetic-custom_ros.rosinstall
wstool update -t src

sudo dd if=/dev/zero of=swapfile bs=1M count=3072
sudo mkswap swapfile
sudo swapon swapfile

rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r --os=debian:jessie
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j4

sudo swapoff swapfile
sudo rm swapfile

source ~/ros_catkin_ws/install_isolated/setup.bash



echo " "
echo "------------"
echo "------------"
echo " "
echo "the END"
echo " "
echo "Enjoy!"

#!/bin/bash



echo "Hello there!"
echo " "
echo " "
echo "Let's intall ROS-Comm Kinetic on Rasbian Buster"
echo " "
echo "This script just works for ROS Kinetic on Rasbian Buster..."
echo "Don't expect it to work otherwise"
echo " "
echo "Ctl-C to exit"
echo " "



echo "1.- Setup ROS Repositories"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo "2.- Updating"

sudo apt-get update

echo "3.- Upgrading"

sudo apt-get upgrade -y

echo "4.- Install Bootstrap Dependencies"

sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake

echo "5.- Initializing rosdep"

sudo rosdep init
rosdep update

echo "6.- Creating a catkin Workspace"

mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

echo "7.- Fetching the core packages for ROS-Comm, no GUI tools"

rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall
wstool init src kinetic-ros_comm-wet.rosinstall


echo "8.- Resolving Dependencies"

mkdir -p ~/ros_catkin_ws/external_src
cd ~/ros_catkin_ws/external_src
wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
cmake .
make
sudo make install

cd ~/ros_catkin_ws
rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:buster



echo "9.- Building the catkin Workspace"

sudo apt remove libboost1.67-dev
sudo apt autoremove
sudo apt install -y libboost1.58-dev libboost1.58-all-dev
sudo apt install -y g++-5 gcc-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 20
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++
sudo apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake

sudo dd if=/dev/zero of=swapfile bs=1M count=3072
sudo mkswap swapfile
sudo swapon swapfile

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j2

echo "ROS installed!!!"

source /opt/ros/kinetic/setup.bash
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

echo "10.- Updating the Workspace"

mv -i kinetic-ros_comm-wet.rosinstall kinetic-ros_comm-wet.rosinstall.old
rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall
diff -u kinetic-ros_comm-wet.rosinstall kinetic-ros_comm-wet.rosinstall.old
wstool merge -t src kinetic-ros_comm-wet.rosinstall
wstool update -t src
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j2
source ~/ros_catkin_ws/install_isolated/setup.bash

echo "10.- Adding Released Packages"

cd ~/ros_catkin_ws
rosinstall_generator ros_comm ros_control --rosdistro kinetic --deps --wet-only --tar > kinetic-custom_ros.rosinstall

wstool merge -t src kinetic-custom_ros.rosinstall
wstool update -t src

rosdep install --from-paths src --ignore-src --rosdistro kinetic -y -r --os=debian:buster
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic -j2

sudo swapoff swapfile
sudo rm swapfile

echo " "
echo "------------"
echo "------------"
echo " "
echo "the END"
echo " "
echo "Enjoy!"


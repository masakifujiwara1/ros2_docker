FROM masakifujiwara1/cuda:117-pytorch2.0-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update -qq
RUN apt-get install -y tzdata
RUN apt-get update && apt-get install -y vim git lsb-release sudo gnupg htop gedit tmux curl

# ros2 humble setup
RUN git clone --depth 1 https://github.com/ryuichiueda/ros2_setup_scripts
RUN ./ros2_setup_scripts/setup.bash -xv

# RUN apt-get install -y gazebo ros-humble-gazebo-* 
RUN apt-get install -y ros-humble-rqt-* 

# set ros2 workspace
COPY config/git_clone.sh /home/git_clone.sh
RUN . /opt/ros/humble/setup.sh
RUN mkdir -p ros2_ws/src && cd ~/ros2_ws && colcon build
RUN cd ~/ros2_ws/src && . /home/git_clone.sh

# clean workspace
RUN rm -rf git_clone.sh ros2_setup_scripts

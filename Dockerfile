FROM osrf/ros:foxy-desktop

WORKDIR /home
ENV HOME /home

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# install vim
RUN apt-get update -qq
RUN apt-get install -y tzdata
RUN apt-get update && apt-get install -y vim git lsb-release sudo gnupg tmux

# install python3
# RUN apt-get install -y python3 python3-pip

# install pytorch
# RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# ros2 humble setup
# RUN git clone --depth 1 https://github.com/ryuichiueda/ros2_setup_scripts
# RUN ./ros2_setup_scripts/setup.bash -xv

# RUN apt-get install -y gazebo ros-humble-gazebo-* 
# RUN apt-get install -y ros-humble-rqt-* 

# set ros2 workspace
COPY config/git_clone.sh /home/git_clone.sh
RUN . /opt/ros/foxy/setup.sh
RUN mkdir -p ros2_ws/src && cd ~/ros2_ws && colcon build
RUN cd ~/ros2_ws/src && . /home/git_clone.sh
# RUN . /opt/ros/humble/setup.sh && cd ~/ros2_ws && colcon build --symlink-install
# RUN source /opt/ros/humble/setup.bash && source ~/ros2_ws/install/local_setup.bash

COPY config/.bashrc /home/.bashrc
COPY config/.vimrc /home/.vimrc

# clean workspace
RUN rm -rf git_clone.sh

# RUN apt-get install -y ros-humble-dynamixel-sdk ros-humble-turtlebot3-msgs ros-humble-turtlebot3

# RUN cd ~/ros2_ws/src && git clone -b humble-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git

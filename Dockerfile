ARG ROS_DISTRO=humble
ARG ROS_PKG=desktop
FROM osrf/ros:${ROS_DISTRO}-${ROS_PKG}-full

SHELL ["/bin/bash", "-c"]

# GPG keys and sources for ROS 2
RUN grep -lr 'http://packages.ros.org/ros2/ubuntu' /etc/apt/sources.list /etc/apt/sources.list.d/* | xargs rm -f || true && \
    rm -f /usr/share/keyrings/ros-archive-keyring.gpg /usr/share/keyrings/ros2-latest-archive-keyring.gpg /etc/apt/trusted.gpg.d/ros2.gpg || true && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
      | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y 

ARG USER_ID=1000
ARG USER_GID=$USER_ID
ARG USER_NAME=ubuntu
ARG PASSWORD=ubuntu

RUN if id -u $USER_ID ; then userdel `id -un $USER_ID`; fi 

RUN groupadd --gid $USER_GID $USER_NAME && \
    useradd --uid $USER_ID --gid $USER_GID -m $USER_NAME && \
    apt-get update && \
    apt-get install -y sudo && \
    echo $USER_NAME:$PASSWORD | chpasswd && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/$USER_NAME
ENV TERM=xterm-256color

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN echo 'Asia/Tokyo' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && DEBIAN_FRONTEND=noninteractive && \
    apt-get install -q -y --no-install-recommends \
        tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive && \
    apt-get install -q -y --no-install-recommends \
        locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    x11-apps \
    mesa-utils \
    apt-utils \
    can-utils \
    net-tools \
    curl \
    lsb-release \
    less \
    tmux \
    command-not-found \
    git \
    xsel \
    vim \
    wget \
    gedit \
    gnupg2 \
    build-essential \
    python3-dev \
    python3-pip \
    xdg-utils \
    nautilus \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    ros-${ROS_DISTRO}-rqt-* \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-ros-ign && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $USER_NAME
WORKDIR /home/$USER_NAME

RUN mkdir -p /home/$USER_NAME/ros2_ws/src && \
    cd /home/$USER_NAME/ros2_ws && \
    colcon build --symlink-install && \
    rosdep update

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
echo "source /home/$USER_NAME/ros2_ws/install/setup.bash" >> ~/.bashrc

RUN git clone https://github.com/masakifujiwara1/tmux_config.git && \
    cp tmux_config/.tmux.conf ~/ && \
    rm -rf tmux_config

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

COPY --chown=$USER_NAME:$USER_NAME entrypoint.sh /home/$USER_NAME/entrypoint.sh
RUN sudo chmod +x /home/$USER_NAME/entrypoint.sh
ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]

CMD ["bash"]
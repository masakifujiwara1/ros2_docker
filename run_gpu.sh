#!/bin/bash

eval "docker container run --network host --gpus all -it --name my-humble -e DISPLAY=$DISPLAY --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v $PWD/docker_share:/home/host_files --privileged --env="XAUTHORITY=$XAUTH" -v "$XAUTH:$XAUTH" --env="QT_X11_NO_MITSHM=1" --ipc=host masakifujiwara1/ros2:humble"

# ros2_docker
「Ubuntu + ROS2 」を含むDocker環境を提供します.  
Provides a Docker environment including "Ubuntu + ROS2".

## Prerequisites
- docker installed [How to Install(ubuntu20.04)](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04-ja)
- nvidia-smi must be available (When using gpu)

## Quick Start
Run the docker container. Add the `--rm` option depending on the situation.  
※ If you do not want to save your changes, it is recommended to use the `--rm` option.
```
./run.sh
```

## After the second
launch (Rename containers as necessary)
```
docker start my-humble
```
login
```
./login.sh
```
close (Rename containers as necessary)
```
docker stop my-humble
```

## Build (option)
If you want to customize `.bashrc` or `.vimrc`, please change the files in config/.  
After the change, execute the following command.
```
./build.sh
```
※ In this case, it is necessary to change the image used in run.sh

## Details of each branch
writing

## Docker tags on hub.docker.com
writing

## Related Projects
* https://github.com/masakifujiwara1/cuda_pytorch_ros2_docker
  * under maintenance
* https://github.com/masakifujiwara1/cuda_pytorch_ros1_docker
  * under maintenance
* https://github.com/masakifujiwara1/ros1_docker
  * under maintenance

## License
BSD

## Tested on ...
- ubuntu 20.04 LTS

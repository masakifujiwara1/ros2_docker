#!/bin/bash
set -e

# ROS 2の環境設定を読み込む
source /opt/ros/${ROS_DISTRO}/setup.bash

# 引数として渡されたコマンドを実行
exec "$@"

#!/bin/bash

source /ws_livox/devel/setup.sh
roscore & sleep 5
roslaunch camera_lidar_calibration cameraCalib.launch

#!/bin/bash

# Define the ROSDEP_IGNORE variable
ROSDEP_IGNORE="urdf_test omni_drive_controller orocos_kdl pal_filters libgazebo9-dev pal_usb_utils speed_limit_node camera_calibration_files pal_moveit_plugins pal_startup_msgs pal_local_joint_control pal_pcl_points_throttle_and_filter current_limit_controller hokuyo_node dynamixel_cpp pal_moveit_capabilities pal_pcl dynamic_footprint gravity_compensation_controller pal-orbbec-openni2 pal_loc_measure pal_map_manager ydlidar_ros_driver"

# Update package information
apt-get update

# Install ROS package dependencies using rosdep
rosdep install --from-paths src --ignore-src -y --rosdistro noetic --skip-keys="${ROSDEP_IGNORE}"

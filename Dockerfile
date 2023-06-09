FROM osrf/ros:noetic-desktop-full-focal

# original maintainer="Yue Erro <yue.erro@pal-robotics.com>"
#I have adapted this for use in my project, since this is what the project was based on 
LABEL maintainer="Alexander Robins <ed19ar3@leeds.ac.uk>"
ARG REPO_WS=/tiago_public_ws
ARG SOURCE_DIR=/source_dir

# Create the workspace directory and set it as the working directory
RUN mkdir -p ${REPO_WS}/src
WORKDIR ${REPO_WS}

# Create a symbolic link from the SOURCE_DIR/src to REPO_WS/src
RUN ln -s ${SOURCE_DIR} ${REPO_WS}
COPY ./ ${REPO_WS}
# Set up the volume
VOLUME ${SOURCE_DIR}

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-vcstool \
    apt-utils \
    libv4l-dev \
    libv4l2rds0 \
    git \
    wget \
    vim \
    locales \
    dpkg \
    ssh \
    curl \
    aptitude \
    g++ \
    gcc \
    openvpn \
    gnupg \
    bash-completion \
    vim-gtk3 \
    nano \
    psmisc \
    ccache \
    gdb \
    qtcreator \
    htop \
    man \
    meld \
    silversearcher-ag \
    terminator \
    tig \
    valgrind \
    iputils-ping \
    ipython3 \
    python-is-python3 \
    python3-scipy \
    python3-wstool \
    python3-networkx \
    python3-pip  \
    python3-vcstool \
    python3-rosinstall \
    python3-catkin-tools \
    ros-noetic-actionlib-tools \
    ros-noetic-moveit-commander \
    
  && rm -rf /var/lib/apt/lists/*


ARG ROSDEP_IGNORE="urdf_test omni_drive_controller orocos_kdl pal_filters libgazebo9-dev pal_usb_utils speed_limit_node camera_calibration_files pal_moveit_plugins pal_startup_msgs pal_local_joint_control pal_pcl_points_throttle_and_filter current_limit_controller hokuyo_node dynamixel_cpp pal_moveit_capabilities pal_pcl dynamic_footprint gravity_compensation_controller pal-orbbec-openni2 pal_loc_measure pal_map_manager ydlidar_ros_driver"

RUN apt-get update && rosdep install --from-paths ${REPO_WS}/src --ignore-src -y --rosdistro noetic --skip-keys="${ROSDEP_IGNORE}"

RUN pip3 install torch>=1.10.0 torchvision opencv-python seaborn thop requests tqdm pyyaml pyrealsense2 numpy==1.23.5

RUN bash -c "source /opt/ros/noetic/setup.bash \
    && catkin build ros_3d_bb \
    && catkin build -DCATKIN_ENABLE_TESTING=0 -j $(expr `nproc` / 2) \
    && echo 'source $REPO_WS/devel/setup.bash' >> ~/.bashrc"

ENTRYPOINT ["bash"]

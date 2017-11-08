FROM osrf/ros:kinetic-desktop-full


RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# Install some basic tools 
RUN apt-get update && apt-get install -y \
    build-essential \
    moreutils \
    software-properties-common \
    nano \
    vim \
    sudo \
    git \
    autoconf \
    automake \
    libtool \
    curl \
    make \
    g++ \
    unzip

# install dependencies
RUN sudo apt-get install -y \
    ninja-build \
    python-catkin-tools \ 
    libglew-dev \
    libopencv-dev \
    ros-kinetic-rosbuild


# build + install pangolin
RUN cd /tmp/ && git clone https://github.com/stevenlovegrove/Pangolin.git  && cd Pangolin && git checkout v0.5 && mkdir build && cd build && cmake .. && cmake --build . && make && make install && cd ../.. && rm -rf Pangolin 

# init catkin workspace
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && mkdir -p /home/container/ws/src && cd /home/container/ws/src && catkin_init_workspace && cd .. && catkin build"

# build ORB_SLAM2
RUN cd /home/container && git clone https://github.com/raulmur/ORB_SLAM2.git && cd ORB_SLAM2 && ./build.sh 

# build ORB_SLAM2 ros package
RUN /bin/bash -c "cd /home/container/ORB_SLAM2 && source /opt/ros/kinetic/setup.bash && export ROS_PACKAGE_PATH=/opt/ros/kinetic/share:/home/container/ORB_SLAM2/Examples/ROS && env && rosdep update && ./build_ros.sh"

# add entrypoint
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

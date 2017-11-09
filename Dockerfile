FROM roblabfhge/ros:kinetic

# install dependencies
RUN sudo apt-get install -y \
    libglew-dev \
    libopencv-dev 

# build + install pangolin
RUN cd /tmp/ && git clone https://github.com/stevenlovegrove/Pangolin.git  && cd Pangolin && git checkout v0.5 && mkdir build && cd build && cmake .. && cmake --build . && make && make install && cd ../.. && rm -rf Pangolin 

# build ORB_SLAM2
RUN cd /home/container && git clone https://github.com/raulmur/ORB_SLAM2.git && cd ORB_SLAM2 && ./build.sh 

# build ORB_SLAM2 ros package
RUN /bin/bash -c "cd /home/container/ORB_SLAM2 && source /opt/ros/kinetic/setup.bash && export ROS_PACKAGE_PATH=/opt/ros/kinetic/share:/home/container/ORB_SLAM2/Examples/ROS && env && rosdep update && ./build_ros.sh"

# add entrypoint
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

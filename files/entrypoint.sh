#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
chown -R $USER_ID:$USER_ID /home/container

useradd --shell /bin/bash -p $(openssl passwd -crypt docker) -u $USER_ID -U -G sudo -o -c "" container
echo "sudo ALL=(ALL:ALL) ALL" >> /etc/sudoers

set -e

# init
if [ ! -e /home/container/.bashrc ]
then
  	source "/opt/ros/$ROS_DISTRO/setup.bash"
	cd ~
	
	# setup ros environment
 	echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /home/container/.bashrc
  	echo 'cd ~' >> /home/container/.bashrc
    echo 'source ~/ws/devel/setup.bash' >> /home/container/.bashrc
    echo 'export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/container/ORB_SLAM2/Examples/ROS' >> /home/container/.bashrc
fi

#service mongodb start

exec /usr/local/bin/gosu container "$@"


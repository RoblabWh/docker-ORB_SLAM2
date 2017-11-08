#!/bin/bash

xhost + local:
QT_GRAPHICSSYSTEM="native" docker run -it --rm \
	--name container_orb_slam2 \
    --privileged \
   	-e DISPLAY=unix$DISPLAY \
	-e LOCAL_USER_ID=`id -u $USER` \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/machine-id:/etc/machine-id \
    -v config:/home/tradr/ORB_SLAM2/config \
	--network="host" \
	roblabfhge/orb_slam2 \
	bash 

xhost -local:

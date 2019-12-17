#!/bin/bash

git clone https://github.com/kylemanna/docker-openvpn.git && cd docker-openvpn
    # create a copy with the current architecture
    DOCKERFILE_CUSTOM=Dockerfile.`uname -m`
    cp Dockerfile.aarch64 $DOCKERFILE_CUSTOM     

    # Upgrade Alpine Image for OpenVPN 
    IMAGE_LINE=`cat -n $DOCKERFILE_CUSTOM | grep FROM |  awk '{print $1}'`	 # search line with the old Image
    sed -i ${IMAGE_LINE}d $DOCKERFILE_CUSTOM				                            # delete this old Image
    sed -i "${IMAGE_LINE}a\FROM alpine:3.8" $DOCKERFILE_CUSTOM            # append new Image

    docker build --no-cache -t kylemanna/openvpn -f $DOCKERFILE_CUSTOM .
    cd .. && rm -f -r docker-openvpn


echo "Image create sucessfull"

docker run -it --rm kylemanna/openvpn uname -m

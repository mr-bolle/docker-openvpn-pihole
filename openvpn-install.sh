#!/bin/bash
# Aurthor: Muhammad Asim
# CoAuthor mr-bolle

#Purpose: Setup OpenVPN in quick time. https://www.youtube.com/watch?v=NQpzIh7kSkY

#We we are pulling the best Image of docker for OpenVPN on earth.

set -euo pipefail

echo -e "\nWe we are pulling the best Image of OpenVPN for docker on earth by kylemanna/openvpn\n"

docker pull kylemanna/openvpn

#Step 1

echo -e "\nStep 1\n"
sleep 1
echo -e "\nPerforming Step 1, we are going to make a directory at /openvpn_data\n"

mkdir -p $PWD/openvpn_data


OVPN_DATA=$PWD/openvpn_data

echo -e "\n$OVPN_DATA\n"

export OVPN_DATA

sleep 1
read -p "Please enter your dynDNS Addess: " IP

# VPN Protocol 
read -p "Please choose your Protocol (tcp / [udp])?: " PROTOCOL
    
    if [ "$PROTOCOL" != "tcp" ]; then

        PROTOCOL="udp"   # set the default Protocol
        echo -e "\n  Your Domain is: $PROTOCOL://$IP \n"
    else
        echo -e "\n  Your Domain is: $PROTOCOL://$IP \n"
    fi

# Pi-Hole Container
read -p "Please enter the Pi-Hole Container IP [default 172.110.1.4]: " PIHOLEIP
    PIHOLEIP=${PIHOLEIP:-'172.110.1.4'}   # set the default IP

    if [[ $PIHOLEIP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "\n  This is a valid IP: $PIHOLEIP"
    else
        echo -e "\n*****************************************************\n"
        echo -e "\n  This is a invalid IP: "$PIHOLEIP", please try again!"
        echo -e "\n*****************************************************\n"
        sleep 3 && exit
    fi

#Step 2
echo -e "\nStep 2\n"
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -n $PIHOLEIP -u $PROTOCOL://$IP 
# more Option: https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_genconfig


##*****###   finish for the first :)


echo -e "\nAfter a Shortwhile You need to enter your Server Secure Password details please wait ...\n"

#Step 3
sleep 3

echo -e "\nWe are now at Step 3\n"

docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki



#Step 4
## nicht notwendig, da der container später gestartet wird
#sleep 1
#echo -e "\nStep 4, We are Starting OpenVPN server process please wait ...\n"

# docker run --name vpn_openvpn -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

#sleep 3

#echo "\nSee I am up and running Alhumdulliah\n"

#docker ps -a

#echo -e "\nMy name is OpenVPN, I am running inside the container name OpenVPN\n"

#sleep 3

#Step 5
echo -e "\nWe are now at 5th Step, Generate a client certificate with  a passphrase SAME AS YOU GIVE FOR SERVER...PASSPHRASE please wait...\n"

sleep 1
read -p "Please Provide Your Client Name " CLIENTNAME

echo -e "\nI am adding a client with name $CLIENTNAME\n"
 
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass


#Step 6
echo -e "\nWe are now at 6TH Step, don't worry this is last step, you lazy GUY,Now we retrieve the client configuration with embedded certificates\n"


echo -e "\n$CLIENTNAME ok\n"

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

cp $PWD/$CLIENTNAME.ovpn $OVPN_DATA


#Note: If you remove the docker container by mistake, simply copy and paster 4TH Step, all will set as previously.

#END

#To revoke a client or user 
# docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn ovpn_revokeclient 1234 remove﻿ 

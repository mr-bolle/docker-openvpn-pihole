#!/bin/bash

# Aurthor: Muhammad Asim
# CoAuthor mr-bolle

#Purpose: Setup OpenVPN in quick time. https://www.youtube.com/watch?v=NQpzIh7kSkY

#We we are pulling the best Image of docker for OpenVPN on earth.

set -euo pipefail

echo -e "\nWe we are pulling the best Image of OpenVPN for docker on earth by kylemanna/openvpn\n"

# build openvpn image if current device is a ex. Raspberry Pi 2
if [ `uname -m` != 'x86_64' ]; then
        echo "Build a Docker Image from the kylemanna/openvpn repository"
        # docker build -t kylemanna/openvpn https://github.com/kylemanna/docker-openvpn.git
            git clone https://github.com/kylemanna/docker-openvpn.git && cd docker-openvpn
                # change alpine image
                    sed -i "/FROM/s/latest/3.8/g" Dockerfile
                    docker build --no-cache -t kylemanna/openvpn .
                cd .. && rm -f -r docker-openvpn    
    else
        docker pull kylemanna/openvpn
fi


#Step 1
sleep 1

echo -e "\nPerforming Step 1, we are going to make a directory at /openvpn_data\n"

mkdir -p $PWD/openvpn_data && OVPN_DATA=$PWD/openvpn_data

echo -e "** OpenVPN Data Path is set to: $OVPN_DATA  **\n"

export OVPN_DATA

sleep 1

# OpenVPN dynDNS Domain (ex vpn.example.com:443)
read -p "Please enter your dynDNS Address:            " IP

# VPN Protocol 
read -p "Please choose your Protocol (tcp / [udp]):   " PROTOCOL
    
    if [ "$PROTOCOL" != "tcp" ]; then

        PROTOCOL="udp"   # set the default Protocol 
        # echo -e "\n***********************************************************"
        # echo -e "\n * Your Domain is: $PROTOCOL://$IP *"
        # echo -e "\n***********************************************************"
    else
        PROTOCOL="tcp"   # change Protocol to tcp
        # echo -e "\n***********************************************************"
        # echo -e "\n * Your Domain is: $PROTOCOL://$IP *"
        # echo -e "\n***********************************************************"
    fi

# Pi-Hole Host-IP set to docker-compose as ServerIP Environment
# read current ServerIP
HostIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

    # change HostIP
    HostIP_OLD=`grep 'ServerIP' docker-compose.yml | awk '{print $2}'`
        if [ $HostIP_OLD != $HostIP ]; then
                # docker-compose Pihole ServerIP not equal HostIP
                sed -in "/ServerIP/s/$HostIP_OLD/$HostIP/g" docker-compose.yml        # search for ServerIP and replace HostIP
            #else
                #echo "HostIP same, change is not necessary"
        fi

# set the Pi-Hole Web Admin Password
# read current PiHole Admin Password from docker-compose.yml
PIHOLE_PASSWORD_OLD=`grep 'WEBPASSWORD' docker-compose.yml | awk '{print $2}'`

# Pi-Hole Web Admin Password
read -p "Please enter the Pi-Hole Container IP (default [$PIHOLE_PASSWORD_OLD]): " PIHOLE_PASSWORD_NEW
    PIHOLE_PASSWORD_NEW=${PIHOLE_PASSWORD_NEW:-$PIHOLE_PASSWORD_OLD}   # set the default Password (if user skip this entry)

#    echo "new: $PIHOLE_PASSWORD_NEW"
#    echo "old: $PIHOLE_PASSWORD_OLD"

            if [ "$PIHOLE_PASSWORD_NEW" != $PIHOLE_PASSWORD_OLD ]; then
                # change password
                sed -in "/WEBPASSWORD/s/$PIHOLE_PASSWORD_OLD/$PIHOLE_PASSWORD_NEW/g" docker-compose.yml        # search for WEBPASSWORD and replace this Password
                PIHOLE_PASSWORD_now=`grep 'WEBPASSWORD' docker-compose.yml | awk '{print $2}'`
        
        # echo -e "\n***********************************************************"
        # echo -e "\n * New Pi-Hole Password is set: $PIHOLE_PASSWORD_now *"
        # echo -e "\n***********************************************************"
        
            else
                # use default password
                PIHOLE_PASSWORD_now=`grep 'WEBPASSWORD' docker-compose.yml | awk '{print $2}'`
                
        # echo -e "\n***********************************************************"
        # echo -e "\n * You don't change Pi-Hole Password: $PIHOLE_PASSWORD_now *"
        # echo -e "\n***********************************************************"             
            fi


# Pi-Hole & OpenVPN Container IP set to docker-compose

# # read current Container IP

##  ** stop this idea  **
#     OpenVPN_IP_OLD=`grep 'ipv4' docker-compose.yml | awk ' NR==1 {print $2}'`      # first IPv4
#     OpenVPN_IP_OLD_LINE=`grep --line-number 'ipv4' docker-compose.yml | awk ' NR==1 {print $1}' |  sed 's/[^0-9]*//g'`  # first result from ipv4 return linenumber (without :)

#     PIHOLE_IP_OLD=`grep 'ipv4' docker-compose.yml | awk ' NR==2 {print $2}'`       # secont IPv4
#     PIHOLE_IP_OLD_LINE=`grep --line-number 'ipv4' docker-compose.yml | awk ' NR==2 {print $1}' | sed 's/[^0-9]*//g'`  # first result from ipv4 return linenumber (without :)

# read -p "Please enter the Pi-Hole Container IP [default $PIHOLE_IP_OLD]: " PIHOLE_IP
#     PIHOLE_IP=${PIHOLE_IP:-$PIHOLE_IP_OLD}   # set the default IP (if user skip this entry)

#     if [[ $PIHOLE_IP != ^[10|172|192].[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
#    # if [[ $PIHOLE_IP != '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ]]; then
#     #    echo -e "\n  This is a valid IP: $PIHOLE_IP  Line: $PIHOLE_IP_OLD_LINE $PIHOLE_IP"

#         sed -in "${PIHOLE_IP_OLD_LINE}s/${PIHOLE_IP_OLD}/${PIHOLE_IP}/g" docker-compose.yml  # replace replacing-string-based-on-line-number
#         echo `grep 'ipv4' docker-compose.yml | awk ' NR==2 {print $2} '`

# #        sed -in "/ServerIP/s/$HostIP_OLD/$HostIP/g" docker-compose.yml
#     else
#         echo -e "\n*****************************************************\n"
#         echo -e "\n  This is a invalid IP: "$PIHOLE_IP", please try again!"
#         echo -e "\n*****************************************************\n"
#         sleep 3 && exit
#     fi


#Step 2
echo -e "\nStep 2\n"

# read IPv4 from Pi-Hole Container 
PIHOLE_IP=`grep 'ipv4' docker-compose.yml | awk ' NR==2 {print $2}'`
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -n $PIHOLE_IP -u $PROTOCOL://$IP 
# more Option: https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_genconfig


echo -e "\nAfter a Shortwhile You need to enter your Server Secure Password details please wait ...\n"

#Step 3
sleep 3

echo -e "\nWe are now at Step 3\n"
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

#Step 4
echo -e "\nWe are now at 4th Step, Generate a client certificate with  a passphrase SAME AS YOU GIVE FOR SERVER...PASSPHRASE please wait...\n"

sleep 1
read -p "Please Provide Your Client Name " CLIENTNAME

# echo -e "\nI am adding a client with name $CLIENTNAME\n"
 
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass


#Step 5
echo -e "\nWe are now at 5TH Step, don't worry this is last step, you lazy GUY,Now we retrieve the client configuration with embedded certificates\n"

echo -e "\n$CLIENTNAME ok\n"

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

cp $PWD/$CLIENTNAME.ovpn $OVPN_DATA


# Show all values
echo -e "\n ____________________________________________________________________________"
echo -e "    Your VPN Domain is:                $PROTOCOL://$IP"
echo -e "    Your Pi-Hole Password is set:      $PIHOLE_PASSWORD_now"
echo -e "    Your Pi-Hole Admin Page is set to: http://$HostIP:8081/admin"
echo -e "   ____________________________________________________________________________\n"

#Note: If you remove the docker container by mistake, simply copy and paster 4TH Step, all will set as previously.

#END

#To revoke a client or user 
# docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn ovpn_revokeclient 1234 remove

# *******************************************************************************************************************


# create a new sub-network (if not exist)
docker network inspect vpn-net &>/dev/null || 
    docker network create --driver=bridge --subnet=172.110.1.0/24 --gateway=172.110.1.1 vpn-net

# set DNSSEC=true to pihole/setupVars.conf 
mkdir -p pihole && echo "DNSSEC=true" >> pihole/setupVars.conf
echo "API_QUERY_LOG_SHOW=blockedonly" >> pihole/setupVars.conf

# run docker-compose
docker-compose up -d
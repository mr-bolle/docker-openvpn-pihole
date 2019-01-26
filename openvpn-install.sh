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

echo -e "** Note: you can select the default [Value default] with hit enter **\n"

# OpenVPN dynDNS Domain (ex vpn.example.com:443)
read -p "Please enter your dynDNS Addess: " IP

# VPN Protocol 
read -p "Please choose your Protocol (tcp / [udp])?: " PROTOCOL
    
    if [ "$PROTOCOL" != "tcp" ]; then

        PROTOCOL="udp"   # set the default Protocol 
        echo -e "\n  Your Domain is: $PROTOCOL://$IP \n"
    else
        echo -e "\n  Your Domain is: $PROTOCOL://$IP \n"
    fi

# Pi-Hole Container IP
#  Work in Progress - no adjstment possible

read -p "Please enter the Pi-Hole Container IP [default 172.110.1.4]: " PIHOLEIP
    PIHOLEIP=${PIHOLEIP:-'172.110.1.4'}   # set the default IP (if user skip this entry)

    if [[ $PIHOLEIP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "\n  This is a valid IP: $PIHOLEIP"
    else
        echo -e "\n*****************************************************\n"
        echo -e "\n  This is a invalid IP: "$PIHOLEIP", please try again!"
        echo -e "\n*****************************************************\n"
        sleep 3 && exit
    fi

# set the current Path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "OVPN_PiholePath=$DIR" > $DIR/.env         # create each run a new file !!

# set the Pi-Hole Web Admin Password

# read current PiHole Admin Password from docker-compose.yml
PIHOLE_PASSWORD_OLD=`grep 'WEBPASSWORD' $DIR/docker-compose.yml | awk '{print $2}'`

# Pi-Hole Web Admin Password
read -p "Would you change the Pi-Hole Admin Password? [default $PIHOLE_PASSWORD_OLD]: " PIHOLE_PASSWORD_NEW
    PIHOLE_PASSWORD_NEW=${PIHOLE_PASSWORD_NEW:-$PIHOLE_PASSWORD_OLD}   # set the default Password (if user skip this entry)

#    echo "new: $PIHOLE_PASSWORD_NEW"
#    echo "old: $PIHOLE_PASSWORD_OLD"

    # change password
            if [ "$PIHOLE_PASSWORD_NEW" != $PIHOLE_PASSWORD_OLD ]; then
                sed -in "/WEBPASSWORD/s/$PIHOLE_PASSWORD_OLD/$PIHOLE_PASSWORD_NEW/g" $DIR/docker-compose.yml        # search for WEBPASSWORD and replace this Password
                PIHOLE_PASSWORD_now=`grep 'WEBPASSWORD' $DIR/docker-compose.yml | awk '{print $2}'`
            
        echo -e "\n*****************************************************"
        echo -e "\n  New Pi-Hole Password is set: $PIHOLE_PASSWORD_now  "
        echo -e "\n*****************************************************"


            else
                # use default password
                PIHOLE_PASSWORD_now=`grep 'WEBPASSWORD' $DIR/docker-compose.yml | awk '{print $2}'`
                
        echo -e "\n***********************************************************"
        echo -e "\n  You don't change Pi-Hole Password: $PIHOLE_PASSWORD_now  "
        echo -e "\n***********************************************************"             

            fi

#Step 2
echo -e "\nStep 2\n"
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -n $PIHOLEIP -u $PROTOCOL://$IP 
# more Option: https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_genconfig


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
# docker run --volumes-from ovpn-data --rm -it kylemanna/openvpn ovpn_revokeclient 1234 remove

# *******************************************************************************************************************

##  create .env for docker-compose.yml

# set the Host-IP for the Pi-Hole SERVERIP
HostIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

echo -e "\nOVPN_PiholePath=$DIR"
echo -e "SERVER_IP=$HostIP\n"

echo "SERVER_IP=$HostIP" >> $DIR/.env


# create a new sub-network (if not exist)
docker network inspect vpn-net &>/dev/null || 
    docker network create --driver=bridge --subnet=172.110.1.0/24 --gateway=172.110.1.1 vpn-net

# run docker-compose
docker-compose up -d -f $DIR/docker-compose.yml
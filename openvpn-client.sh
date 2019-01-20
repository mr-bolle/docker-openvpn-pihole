#!/bin/bash
# Aurthor: Muhammad Asim
# CoAuthor mr-bolle

OVPN_DATA=$PWD/openvpn_data
export OVPN_DATA

#Step 5
echo -e "\nGenerate a client certificate with  a passphrase SAME AS YOU GIVE FOR SERVER...PASSPHRASE please wait...\n"

sleep 1
read -p "Please Provide Your Client Name " CLIENTNAME

echo -e "\nI am adding a client with name $CLIENTNAME\n"
 
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass

#Step 6
echo -e "\nWe are now at 6TH Step, don't worry this is last step, you lazy GUY,Now we retrieve the client configuration with embedded certificates\n"

echo -e "\n$CLIENTNAME ok\n"

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

cp $PWD/$CLIENTNAME.ovpn $OVPN_DATA

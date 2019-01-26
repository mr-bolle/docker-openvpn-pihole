Changelog 

:construction: Work in Progress - [see issue #1](https://github.com/mr-bolle/docker-openvpn-pihole/issues/1)

0.3 2019.01.27
- openvpn-install.sh
  - `.env` is not necessary (ServerIP check and change if different)
  - remove current Path

0.2 2019.01.26
- openvpn-install.sh
  - ~~set the current Path (to run compose / script from differend Directory)~~
  - add possibility to change the OpenVPN Protocol (default udp)
  - add possibility to change the Pi-Hole Admin Password (and read WEBPASSWORD from docker-compose)
  - read the Host-IP IPv4 to `.env` for Pi-Hole ServerIP
  - create a new sub-network if this not exist
  - run docker-compose.yml

:zap: every time you run openvpn-install.sh it creates a new `.env` 

WIP: Pi-Hole Container IP -- change docker-compose & create network

0.1 2019.01.20
### Added
- openvpn-install.sh Script to create the OpenVPN Certificate and first user
- openvpn-client.sh Script to create aditional User
- docker-compose.yml 
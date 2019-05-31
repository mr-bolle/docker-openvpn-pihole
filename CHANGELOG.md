Changelog 

:construction: Work in Progress - [see issue #1](https://github.com/mr-bolle/docker-openvpn-pihole/issues/1)

0.9 2019.05.31
- [CVE-2019-5021](https://www.zdnet.com/article/alpine-linux-docker-images-ship-a-root-account-with-no-password/) fix Alpine image `root account without password` for Raspberry Pi Devices (now use the Image `alpine:latest`)
- add `.gitignore` and fix issue with command `ip` #PR8 thanks @darth-veitcher

0.8 2019.02.17
- [Upgrade to Pihole 4.2.2](https://github.com/pi-hole/docker-pi-hole/pull/426)
- openvpn-install.sh
  - remove ServerIP adjustment in docker-compose.yml
- docker-compose.yml
  - remove `ServerIP`
  - remove fix from issue `nameserver 127.0.0.11` pi-hole/docker-pi-hole#410

0.7 2019.02.17
- openvpn-install.sh
  - set "DNSSEC=true" to pihole/setupVars.conf
  - set "API_QUERY_LOG_SHOW=blockedonly" to pihole/setupVars.conf

- docker-compose.yml
  - change DNS1=46.182.19.48 Digitalcourage and DNS2=213.73.91.35 Chaos Computer Club (this support DNSSecure check this with [DNSSEC Resolver Test](http://dnssec.vs.uni-due.de/))

0.6 2019.02.11
- fix pihole resolv.conf [#410](https://github.com/pi-hole/docker-pi-hole/issues/410)
- fix pihole dns environment

0.5 2019.02.10
- openvpn-install.sh
  - build a image if you use a ARM Device (ex. Raspberry Pi 2) with alpine 3.8 [deepsidhu1313 issue 437](https://github.com/kylemanna/docker-openvpn/issues/437#issuecomment-460019016)

0.4 2019.02.07
- openvpn-install.sh
  - clean up the user input
  - after creating of the Container you get a overview with the OpenVPN Domain, Pi-Hole Password and Pi-Hole Admin Domain

0.3 2019.01.27
- openvpn-install.sh
  - `.env` is not necessary (change ServerIP and WEBPASSWORD into docker-compose.yml directly)
  - remove current Path

0.2 2019.01.26
- openvpn-install.sh
  - ~~set the current Path (to run compose / script from differend Directory)~~
  - add possibility to change the OpenVPN Protocol (default udp)
  - add possibility to change the Pi-Hole Admin Password (and read WEBPASSWORD from docker-compose)
  - read the Host-IP IPv4 to `.env` for Pi-Hole ServerIP
  - create a new sub-network if this not exist
  - run docker-compose.yml

0.1 2019.01.20
### Added
- openvpn-install.sh Script to create the OpenVPN Certificate and first user
- openvpn-client.sh Script to create aditional User
- docker-compose.yml 

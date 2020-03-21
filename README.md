# docker-openvpn-pihole
Create a single docker-compose and use the benefit from pi-hole if you use a Mobile Device outside your Home network.

Rationale for this repository: I want to connect OpenVPN to Pi-Hole as easily as possible. However, the user can make changes (meaningful to me), or just use my preferences.

Many thanks to:  
GitHub @ [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn/)  
GitHub @ [pi-hole/docker-pi-hole](https://github.com/pi-hole/docker-pi-hole/)

Now you can use this repository with the Hardwaretype x86_x64 and amr (Test with **Raspberry Pi 2 (armhf) & Rasperry Pi Zero W (armv6))**

*YouTube: HowTo create this Container in about 4 Minutes*
[![HowTo create this Container in about 4 Minutes](https://abload.de/img/screenshotcpjyo.jpg)](https://www.youtube.com/embed/8sRtCERYVzk)

### :newspaper: [Changelog](https://github.com/mr-bolle/docker-openvpn-pihole/blob/master/CHANGELOG.md)

### 1.0. Preparation
* Docker: [Install Docer](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository)

```
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER
docker --version
```

* Docker-Compose: [Install Docker Compose](https://docs.docker.com/compose/install/#install-compose)  
https://github.com/docker/compose/releases/latest

* Router Port Forwarding [Howto Forward a Port on any Router](https://portforward.com/router.htm)  
Setup a Port Forwarding from the external Port *1194* to the Host-Port *1194*

![OpenVPN Pi-Hole Network Map](images/OpenVPN%20Pi-Hole%20Network.png)


### 1.1. Download and run install Script:
```
git clone https://github.com/mr-bolle/docker-openvpn-pihole.git
cd docker-openvpn-pihole && bash openvpn-install.sh
```

#### 1.2. OpenVPN create certificate and first user [Source](https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md)

Follow User Entry you have to made
:bulb: **All [default] values can be accepted with ENTER** :bulb:
1. `Please enter your dynDNS Addess:` enter your dynDNS Domain (example: `vpn.example.com`)
2. `Please choose your Protocol (tcp / [udp])` you can change the OpenVPN to tcp, default is udp
3. `Would you change your Pi-Hole Admin Password` the currend default password read from docker-compose
4. `Enter PEM pass phrase:` this password is for your ca.key - and you need this to create a User Certificate
5. `Common Name (eg: your user, host, or server name) [Easy-RSA CA]:` (default Easy-RSA CA)
6. `Please Provide Your Client Name` with this Name you create your first OpenVPN Client

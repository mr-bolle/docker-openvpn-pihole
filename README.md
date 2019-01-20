# docker-openvpn-pihole
Create a single docker-compose and use the benefit from pi-hole if you use a Mobile Device outside your Home network.

Rationale for this repository: I want to connect OpenVPN to Pi-Hole as easily as possible. However, the user can make changes (meaningful to me), or just use my preferences.

Many thanks to:  
GitHub @ [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn/)  
GitHub @ [pi-hole/docker-pi-hole](https://github.com/pi-hole/docker-pi-hole/)

### Install and use:
```
git clone https://github.com/mr-bolle/docker-openvpn-pihole.git
cd docker-openvpn-pihole
```
#### 1.1. Edit docker-compose.yml from the pihole Service  
`nano -c docker-compose.yml`  
    * `WEBPASSWORD` pihole Admin Password (default fcvFjLIO2hWhkFCi)  
    * `ServerIP` set the Host-Server IP  
    * :construction: soon it will be possible over user input to adjust this environment

#### 1.2. OpenVPN create certificate and first user [Source](https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md)

`bash openvpn-install.sh`

Follow User Entry you have to made
1. `Please enter your dynDNS Addess:` enter your dynDNS Domain (example: `vpn.example.com`)
2. `Please choose your Protocol (tcp / [udp])` you can change the OpenVPN to tcp, default is udp
3. `Please enter the Pi-Hole Container IP [default 172.110.1.4]` into docker-compose Service Pi-Hole you can set the static IP, this you can adjust or leave it as default
4. `Enter PEM pass phrase:` this password is for your ca.key - and you need this to create a User Certificate
5. `Common Name (eg: your user, host, or server name) [Easy-RSA CA]:` you can press ENTER (default Easy-RSA CA)
6. `Please Provide Your Client Name` with this Name you create your first OpenVPN Client
7. `Enter pass phrase for /etc/openvpn/pki/private/ca.key:` use the PEM password from ca.key from Point 4

#### 1.3. Run docker-compose and set the DNS IP from Pi-Hole 

1. create a own network `docker network create --driver=bridge --subnet=172.110.1.0/24 --gateway=172.110.1.1 vpn-net`
2. run OpenVPN and Pi-Hole Container `docker compose up -d` 
  




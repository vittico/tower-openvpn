#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

sudo apt update
sudo apt -y upgrade
sudo apt install -y aptitude vim htop python-all python-pip build-essential openvpn
sudo cp server.conf /etc/openvpn/
sudo ./iproute.sh


mkdir -p ~/client-configs/keys && mkdir -p ~/client-configs/files
chmod -R 700 ~/client-configs

cp base.conf /home/ubuntu/client-configs/
cp make_config.sh /home/ubuntu/client-configs/
cp revoke.sh /home/ubuntu/client-configs/
chmod +x /home/ubuntu/client-configs/make_config.sh
chmod +x /home/ubuntu/client-configs/revoke.sh


wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz
cd && tar xzpf EasyRSA-nix-3.0.5.tgz && mv EasyRSA-3.0.5 easyrsa && rm EasyRSA-nix-3.0.5.tgz && cp openvpn-install/vars easyrsa && cd easyrsa

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-crl
./easyrsa gen-dh

openvpn --genkey --secret ta.key

sudo cp /home/ubuntu/easyrsa/pki/private/server.key /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/pki/issued/server.crt /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/pki/ca.crt /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/pki/crl.pem /etc/openvpn
sudo cp /home/ubuntu/easyrsa/pki/dh.pem /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/ta.key /etc/openvpn/

cp /home/ubuntu/easyrsa/pki/ca.crt ~/client-configs/keys/
cp /home/ubuntu/easyrsa/ta.key  ~/client-configs/keys/


~/client-configs/make_config.sh client1

sudo systemctl restart openvpn@server

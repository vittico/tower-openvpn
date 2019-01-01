cd ~/easyrsa
./easyrsa revoke $1
./easyrsa gen-crl
sudo cp /home/ubuntu/easyrsa/pki/crl.pem /etc/openvpn
sudo systemctl restart openvpn@server

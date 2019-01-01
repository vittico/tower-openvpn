sudo apt update
sudo apt -y upgrade
sudo apt install -y aptitude vim htop python-all python-pip build-essential openvpn

wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz
cd && tar xzpf EasyRSA-nix-3.0.5.tgz && mv EasyRSA-3.0.5 easyrsa && rm EasyRSA-nix-3.0.5.tgz && cp openvpn-install/vars easyrsa && cd easyrsa

./easyrsa init-pki
./easyrsa build-ca nopass

#./easyrsa init-pki
./easyrsa gen-req server nopass
./easyrsa sign-req server server

sudo cp /home/ubuntu/easyrsa/pki/private/server.key /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/pki/issued/server.crt /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/pki/ca.crt /etc/openvpn/

./easyrsa gen-dh
openvpn --genkey --secret ta.key

sudo cp /home/ubuntu/easyrsa/pki/dh.pem /etc/openvpn/
sudo cp /home/ubuntu/easyrsa/ta.key /etc/openvpn/


mkdir -p ~/client-configs/keys
chmod -R 700 ~/client-configs

./easyrsa gen-req client1 nopass
./easyrsa sign-req client client1

cp /home/ubuntu/easyrsa/pki/private/client1.key ~/client-configs/keys/
cp /home/ubuntu/easyrsa/pki/ca.crt ~/client-configs/keys/
cp /home/ubuntu/easyrsa/ta.key  ~/client-configs/keys/
cp /home/ubuntu/easyrsa/pki/issued/client1.crt ~/client-configs/keys/

cp base.conf /home/ubuntu/client-configs/
cp make_config.sh /home/ubuntu/client-configs/
chmod +x /home/ubuntu/client-configs/make_config.sh

cp /home/ubuntu/easyrsa/pki/ca.crt /home/ubuntu/client-configs/keys/
cp /home/ubuntu/easyrsa/ta.key /home/ubuntu/client-configs/keys/

./easyrsa gen-crl
sudo cp /home/ubuntu/easyrsa/pki/crl.pem /etc/openvpn

#!/bin/sh

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

echo "$(date) - Renew CRL v1.0 - VM - 2022"



if [ ! -d /home/ubuntu/easyrsa ]
then
        echo "$(date) - Renew CRL - ERROR - EASYRSA does not exist!"
        exit 1
fi

cd /home/ubuntu/easyrsa

if [ -f /home/ubuntu/easyrsa/pki/crl.pem ]
then
   echo "$(date) - Renew CRL - BACKING UP CRL..."
   mv /home/ubuntu/easyrsa/pki/crl.pem /home/ubuntu/easyrsa/pki/backup_crl_$(date +"%m_%d_%Y").pem
else
    echo "$(date) - Renew CRL - CRL not found!"
fi

/home/ubuntu/easyrsa/easyrsa gen-crl
if [ $? -eq 0 ]
then
        echo "$(date) - Renew CRL - Succesfully created the new CRL"
else
        echo "$(date) - Renew CRL - ERROR - CRL creation failed"
        exit 1
fi

echo "$(date) - Renew CRL - attempting to update openvpn crl.."
sudo cp /home/ubuntu/easyrsa/pki/crl.pem /etc/openvpn
if [ $? -eq 0 ]
then
        echo "$(date) - Renew CRL - Succesfully updated OpenVPN crl..."
else
        echo "$(date) - Renew CRL - ERROR - CRL update failed"
        exit 1
fi

echo "$(date) - Renew CRL - MD5SUM - $(md5sum /home/ubuntu/easyrsa/pki/crl.pem)"
echo "$(date) - Renew CRL - MD5SUM - $(sudo md5sum /etc/openvpn/crl.pem)"

echo "$(date) - Renew CRL - restarting openvpn..."
sudo systemctl restart openvpn
sudo systemctl status openvpn

echo "$(date) - Renew CRL - All done!"

# crontab: 0 0 1 * * /home/ubuntu/renew-crl.sh >> /home/ubuntu/renew-crl.log

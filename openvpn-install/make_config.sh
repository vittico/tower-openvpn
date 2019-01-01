#!/bin/bash

# First argument: Client identifier

cd ~/easyrsa

./easyrsa gen-req $1 nopass
./easyrsa sign-req client $1


cp /home/ubuntu/easyrsa/pki/private/$1.key ~/client-configs/keys/
cp /home/ubuntu/easyrsa/pki/issued/$1.crt ~/client-configs/keys/

KEY_DIR=~/client-configs/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${1}.ovpn

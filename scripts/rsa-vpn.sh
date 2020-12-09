#!/usr/bin/env bash

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

cd /etc/openvpn/

/usr/share/easy-rsa/3.0.8/easyrsa init-pki

echo 'rasvpn' | /usr/share/easy-rsa/3.0.8/easyrsa build-ca nopass

echo 'rasvpn' | /usr/share/easy-rsa/3.0.8/easyrsa gen-req server nopass

echo 'yes' | /usr/share/easy-rsa/3.0.8/easyrsa sign-req server server

/usr/share/easy-rsa/3.0.8/easyrsa gen-dh

openvpn --genkey --secret ta.key

echo 'client' | /usr/share/easy-rsa/3/easyrsa gen-req client nopass

echo 'yes' | /usr/share/easy-rsa/3/easyrsa sign-req client client

cat /vagrant/config/rsa-server.conf > /etc/openvpn/server.conf

echo 'iroute 192.168.10.0 255.255.255.0' > /etc/openvpn/client/client
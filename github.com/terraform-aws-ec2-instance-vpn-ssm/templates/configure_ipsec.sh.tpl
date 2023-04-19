#!/bin/bash
# This is a simple shell script to rewrite variables for IPSEC configuration.

IPSEC_CONF="/etc/ipsec.conf"
IPSEC_SECRETS=/etc/ipsec.secrets
VPN_IP_INTERNAL=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
VPN_IP_EXTERNAL=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

# Swap out variables in IPSEC_CONF
/bin/sed -i "s:OFFICE_NETWORK:${office_network}:g" $IPSEC_CONF
/bin/sed -i "s:CLIENT_NETWORK:${client_network}:g" $IPSEC_CONF
/bin/sed -i "s:AWS_ENVIRONMENT_NETWORK:${aws_environment_network}:g" $IPSEC_CONF
/bin/sed -i "s/VPN_IP_INTERNAL/$VPN_IP_INTERNAL/g" $IPSEC_CONF
/bin/sed -i "s/AWS_VPN_GATEWAY/$VPN_IP_EXTERNAL/g" $IPSEC_CONF
/bin/sed -i "s:OFFICE_GATEWAY:${office_gateway}:g" $IPSEC_CONF

# Swap out variables in IPSEC_SECRETS
/bin/sed -i "s/AWS_VPN_GATEWAY/$VPN_IP_EXTERNAL/g" $IPSEC_SECRETS
/bin/sed -i "s/OFFICE_GATEWAY/${office_gateway}/g" $IPSEC_SECRETS
/bin/sed -i "s/IPSEC_SHARED_SECRET_KEY/${ipsec_shared_secret_key}/g" $IPSEC_SECRETS

/usr/sbin/service ipsec restart

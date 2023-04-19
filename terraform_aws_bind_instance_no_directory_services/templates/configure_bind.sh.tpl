#!/bin/bash
# This is a simple shell script to rewrite variables for BIND configuration.
BIND_IP_INTERNAL=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4` #bind internal IP address
INTERNAL_ROUTE_53=${internal_route53_address}
NAMED_OPTIONS='/etc/bind/named.conf.options'


#Swap out variables in named.conf.options
/bin/sed -i "s/BIND_IP_INTERNAL/$BIND_IP_INTERNAL/g" $NAMED_OPTIONS
/bin/sed -i "s/INTERNAL_ROUTE_53/$INTERNAL_ROUTE_53/g" $NAMED_OPTIONS

## Truncate named.conf.local - we don't need this
echo "" > /etc/bind/named.conf.local

/usr/sbin/service bind9 restart

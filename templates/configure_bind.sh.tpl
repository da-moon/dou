#!/bin/bash
# This is a simple shell script to rewrite variables for BIND configuration.
BIND_IP_INTERNAL=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4` #bind internal IP address
INTERNAL_ROUTE_53=${internal_route53_address}
NAMED_OPTIONS='/etc/bind/named.conf.options'


DIRECTORY_SERVICES_DOMAIN_NAME=${directory_services_domain}
DIRECTORY_SERVICES_IP_1=${directory_services_ip1} #Directory services IP address 1 of 2
DIRECTORY_SERVICES_IP_2=${directory_services_ip2} #Directory services IP address 2 of 2
NAMED_LOCAL='/etc/bind/named.conf.local'


#Swap out variables in named.conf.options
/bin/sed -i "s/BIND_IP_INTERNAL/$BIND_IP_INTERNAL/g" $NAMED_OPTIONS
/bin/sed -i "s/INTERNAL_ROUTE_53/$INTERNAL_ROUTE_53/g" $NAMED_OPTIONS
/bin/sed -i "s/DIRECTORY_SERVICES_DOMAIN_NAME/$DIRECTORY_SERVICES_DOMAIN_NAME/g" $NAMED_LOCAL
/bin/sed -i "s/DIRECTORY_SERVICES_IP_1/$DIRECTORY_SERVICES_IP_1/g" $NAMED_LOCAL
/bin/sed -i "s/DIRECTORY_SERVICES_IP_2/$DIRECTORY_SERVICES_IP_2/g" $NAMED_LOCAL

/usr/sbin/service bind9 restart

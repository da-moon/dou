#!/bin/bash

set -x

init_services() {
    sudo systemctl stop dcserver
    sudo systemctl stop repotool
    sudo systemctl stop publisher

    rm -rf /usr/Siemens/DeploymentCenter/webserver/.dcserver.pid
    sudo hostnamectl set-hostname "${machine_name}"

    sudo systemctl start dcserver
    sudo systemctl start repotool
    sudo systemctl start publisher

}

update_dns_entry() {
    METADATA_EP="169.254.169.254/latest/meta-data"


    FQDN="${machine_name}.${private_hosted_zone_dns}"
    IP=$(curl "$METADATA_EP"/local-ipv4)
    jq -n -r \
    --arg fqdn "$FQDN" \
    --arg ip "$IP" '
    {
        "Comment": "CREATE/DELETE/UPSERT a record ",
        "Changes": [{
        "Action": "UPSERT",
                    "ResourceRecordSet": {
                                "Name": $fqdn,
                                "Type": "A",
                                "TTL": 300,
                             "ResourceRecords": [{ "Value": $ip}]
    }}]
    }
    ' > /tmp/route53.json


    aws route53 change-resource-record-sets \
    --hosted-zone-id "${private_hosted_zone_arn}" \
    --change-batch file:///tmp/route53.json 

}

echo "Initiating user_data.sh" 
update_dns_entry
init_services
echo "user_data.sh complete!"


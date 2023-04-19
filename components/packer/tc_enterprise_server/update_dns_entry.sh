#!/bin/bash

exec 2>&1 > /var/log/cron_route53.log

export PATH=$PATH:/usr/local/bin

update_dns_entry() {
    METADATA_EP="169.254.169.254/latest/meta-data"


    FQDN="${machine_name}"
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
                                "TTL": 5,
                             "ResourceRecords": [{ "Value": $ip}]
    }}]
    }
    ' > /tmp/route53.json
    sudo chmod 777 /tmp/route53.json


    aws route53 change-resource-record-sets \
    --hosted-zone-id "${private_hosted_zone_arn}" \
    --change-batch file:///tmp/route53.json 

}

echo "Updating route53 record"
date
update_dns_entry
echo "Update finished"


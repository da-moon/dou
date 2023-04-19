#!/bin/bash

echo "Initializing user data on ${machine_name}"

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
                                "TTL": 300,
                             "ResourceRecords": [{ "Value": $ip}]
    }}]
    }
    ' > /tmp/route53.json


    aws route53 change-resource-record-sets \
    --hosted-zone-id "${private_hosted_zone_arn}" \
    --change-batch file:///tmp/route53.json 

}

update_dns_entry

echo "Finished user data"

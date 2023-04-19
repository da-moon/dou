#!/bin/bash

setup_cron_route53() {
    FREQ="* * * * *" # frequency every minute
    LOG_FILE="/var/log/cron_route53.log"
    SCRIPT="/usr/bin/update_dns_entry.sh"

    sudo mv /tmp/update_dns_entry.sh "$SCRIPT"

    sudo touch "$LOG_FILE"
    sudo chmod 777 "$LOG_FILE"
    sudo chmod 777 "$SCRIPT"

    cronline="${FREQ} ${SCRIPT} >/dev/null 2>&1"
    echo "$cronline" > /tmp/tc

    sudo mv /tmp/tc /var/spool/cron
    sudo chown root:root /var/spool/cron/tc
    sudo chmod 600 /var/spool/cron/tc

    echo "(allow unconfined_t user_tmp_t( file ( entrypoint)))" > /tmp/mycron.cil
    sudo semodule -i /tmp/mycron.cil
    sudo systemctl stop crond
    sudo systemctl start crond
}

setup_cron_route53


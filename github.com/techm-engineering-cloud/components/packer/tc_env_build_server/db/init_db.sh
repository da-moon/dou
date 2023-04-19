#!/bin/bash

set -e

DELETE_DATA=$1

run_sql() {
    echo "Getting secrets"
    USER=$(aws secretsmanager get-secret-value --secret-id=${DB_USER} | jq -r '.SecretString')
    PASS=$(aws secretsmanager get-secret-value --secret-id=${DB_PASS} | jq -r '.SecretString')
    SM_USER=$(aws secretsmanager get-secret-value --secret-id=${SM_USER} | jq -r '.SecretString')
    SM_PASS=$(aws secretsmanager get-secret-value --secret-id=${SM_PASS} | jq -r '.SecretString')
    INFODBA_USER=$(aws secretsmanager get-secret-value --secret-id=${INFODBA_USER} | jq -r '.SecretString')
    INFODBA_PASS=$(aws secretsmanager get-secret-value --secret-id=${INFODBA_PASS} | jq -r '.SecretString')
    if [ "$DELETE_DATA" = "delete" ] ; then
        echo "Deleteing old data"
        cat /home/tc/db/delete.sql | sed "s|{sm_db_user}|$SM_USER|; s|{sm_db_pass}|$SM_PASS|; s|{infodba_user}|$INFODBA_USER|; s|{infodba_pass}|$INFODBA_PASS|" > /home/tc/db/delete.sql.tmp
        sqlplus "$USER/$PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HOST})(PORT=1521))(CONNECT_DATA=(SID=${DB_SID})))" @/home/tc/db/delete.sql.tmp
        rm /home/tc/db/delete.sql.tmp
    fi
    echo "Initializing data"
    cat /home/tc/db/create.sql | sed "s|{sm_db_user}|$SM_USER|; s|{sm_db_pass}|$SM_PASS|; s|{infodba_user}|$INFODBA_USER|; s|{infodba_pass}|$INFODBA_PASS|" > /home/tc/db/create.sql.tmp
    sqlplus "$USER/$PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HOST})(PORT=1521))(CONNECT_DATA=(SID=${DB_SID})))" @/home/tc/db/create.sql.tmp
    rm /home/tc/db/create.sql.tmp
}

run_sql

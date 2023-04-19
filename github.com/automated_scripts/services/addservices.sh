#!/bin/bash


kubectl apply -n devops -f gerrit-service.yml,gerrit-mysql-service.yml,jenkins-service.yml,kibana-service.yml,ldap-ltb-service.yml,ldap-phpadmin-service.yml,ldap-service.yml,logstash-service.yml,nexus-service.yml,proxy-service.yml,selenium-hub-service.yml,sensu-api-service.yml,sensu-rabbitmq-service.yml,sensu-redis-service.yml,sensu-uchiwa-service.yml,sonar-mysql-service.yml,sonar-service.yml,elasticsearch-service.yml,kibana-service.yml,logstash-service.yml

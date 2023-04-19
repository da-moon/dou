#!/bin/bash


kubectl apply -n devops -f proxy-pod.yml,ldap-pod.yml,gerrit-mysql-pod.yml,gerrit-pod.yml,sensu-uchiwa-pod.yml,sensu-api-pod.yml,sensu-rabbitmq-pod.yml,sensu-redis-pod.yml,sonar-mysql-pod.yml,sonar-pod.yml,jenkins-pod.yml,selenium-hub-pod.yml,nexus-pod.yml,ldap-ltb-pod.yml,ldap-phpadmin-pod.yml,elasticsearch-pod.yml,kibana-pod.yml,logstash-pod.yml

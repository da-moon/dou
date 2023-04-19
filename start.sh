#!/bin/bash

docker-compose run -d --service-ports nagios
docker exec dockercomposeexample_db_1 /etc/init.d/xinetd start

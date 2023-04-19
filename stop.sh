#!/bin/bash

docker rm --force $(docker-compose ps -q)

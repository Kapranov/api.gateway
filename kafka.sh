#!/usr/bin/env bash


echo -e "\n\n\033[1;32m The run Kafka033[0;0m: \033[1;31mhttp://127.0.0.1/\033[0;0m\033[1;32m9091\033[0;0m\n"

sleep 3s

sudo /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties

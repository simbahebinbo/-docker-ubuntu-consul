#!/bin/bash

# 构建docker镜像

docker build --build-arg CONSUL_NODES=172.18.18.141:8500,172.18.18.142:8500,172.18.18.143:8500,172.18.18.144:8500,172.18.18.145:8500,172.18.18.146:8500 -t consul-consumer .

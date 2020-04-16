#!/bin/bash

# 构建docker镜像

docker build --build-arg CONSUL_NODES=172.26.110.125:8500,172.26.110.122:8500,172.26.111.116:8500,172.26.111.214:8500,172.26.111.41:8500 -t consul-consumer .

#!/bin/bash

# 构建docker镜像

docker build --build-arg CONSUL_NODES=consul-1.sinnet.huobiidc.com:8500,consul-2.sinnet.huobiidc.com:8500,consul-3.sinnet.huobiidc.com:8500,consul-4.sinnet.huobiidc.com:8500,consul-5.sinnet.huobiidc.com:8500,consul-6.sinnet.huobiidc.com:8500 -t consul-consumer .

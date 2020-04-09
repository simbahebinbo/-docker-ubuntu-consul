#!/bin/bash

#用户名
NB_USER=jovyan
#主目录
USER_HOME=/home/${NB_USER}
#工作目录
WORK_DIR=${USER_HOME}/work
#consul的目录
CONSUL_DIR=${WORK_DIR}/consul
#consul可执行文件
CONSUL=/usr/bin/consul
#进程文件
PIDFILE=${WORK_DIR}/consul.pid
#网卡名
ADDR=eth0

#获取容器IP
IP=$(/sbin/ifconfig ${ADDR} | /bin/grep inet | /bin/grep -v 127.0.0.1 | /bin/grep -v inet6 | /usr/bin/awk '{print $2}' | /usr/bin/tr -d "addr:")

# 只允许当前ip注册，即只允许该容器内的应用程序注册
# client 模式
${CONSUL} agent \
-pid-file=${PIDFILE} \
-bootstrap-expect=0 \
-advertise=${IP} -bind=${IP} -client=127.0.0.1 \
-protocol=3 \
-node=consul-consumer \
-rejoin -retry-interval=30s \
-data-dir=${CONSUL_DIR}/data \
-log-file=${CONSUL_DIR}/log/consul.log -log-level=INFO \
-retry-join=172.18.18.142 -retry-join=172.18.18.143 -retry-join=172.18.18.144 -retry-join=172.18.18.145 -retry-join=172.18.18.146 \
-join=172.18.18.142 -join=172.18.18.143 -join=172.18.18.144 -join=172.18.18.145 -join=172.18.18.146

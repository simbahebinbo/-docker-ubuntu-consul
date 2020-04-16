#!/bin/bash

#启动consul程序

#consul可执行文件
CONSUL_BIN=$1
#工作目录
WORK_DIR=$2
#consul的目录
CONSUL_DIR=$3
#应用程序名
APP_NAME=$4
#consul集群的 server agent 链表
CONSUL_SERVERS=$5
#节点名
NODE_NAME=consul-client-${APP_NAME}
#网卡名
ADDR=eth0
#本地IP
LOCAL_IP=127.0.0.1

#获取容器IP
NODE_IP=$(ip -f inet address | grep inet | grep eth0 | awk '{print $2}' | awk -F\/ '{print $1}')


EXEC_SCRIPT_BEDIN=${CONSUL_BIN} agent -bootstrap-expect=0 -advertise=${NODE_IP} -bind=${NODE_IP} -client=${LOCAL_IP} -node=${NODE_NAME} -data-dir=${CONSUL_DIR}/data -log-file=${CONSUL_DIR}/log/${APP_NAME}.log -log-level=INFO 
EXEC_SCRIPT_END=" "

for consul_server in  $(echo ${CONSUL_SERVERS} | tr ',' ' ') 
do
	SERVER_IP=$(echo ${consul_server} | awk -F: '{print $1}')
    EXEC_SCRIPT_END=${EXEC_SCRIPT_END}" -join="${SERVER_IP}
done


# 只允许当前ip注册，即只允许该容器内的应用程序注册到该consul节点
# 以 client 模式启动
# 加入到 server 模式 的节点组成的集群
exec ${EXEC_SCRIPT_BEDIN}${EXEC_SCRIPT_END}


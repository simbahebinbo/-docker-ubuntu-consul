FROM ubuntu:16.04

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

#更新
RUN apt-get update && apt-get install --assume-yes apt-utils

#安装程序依赖的包
RUN apt-get install -yq --no-install-recommends build-essential
RUN apt-get install -yq --no-install-recommends pkg-config

#权限
RUN apt-get install -yq --no-install-recommends sudo

#加密
RUN apt-get install -yq --no-install-recommends openssl
RUN apt-get install -yq --no-install-recommends libssl-dev
RUN apt-get install -yq --no-install-recommends ca-certificates

#编辑器
RUN apt-get install -yq --no-install-recommends vim

#网络
RUN apt-get install -yq --no-install-recommends iputils-ping
RUN apt-get install -yq --no-install-recommends net-tools

#程序管理
RUN apt-get install -yq --no-install-recommends circus
RUN apt-get install -yq --no-install-recommends python-setuptools

#中文支持
RUN apt-get install -yq --no-install-recommends locales

#升级
RUN apt-get -y upgrade

#支持中文
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && locale-gen zh_CN.UTF-8 en_US.UTF-8


# Configure environment
ENV SHELL /bin/bash
ENV NB_USER jovyan
ENV NB_UID 1000
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV USER_HOME /home/$NB_USER
ENV WORK_DIR $USER_HOME/work
ENV CONSUL_DIR $WORK_DIR/consul
ENV CONSUL_BIN /usr/bin/consul


# Create jovyan user with UID=1000 and in the 'users' group
#用户名 jovyan  密码:123456
RUN useradd -p `openssl passwd 123456` -m -s $SHELL -u $NB_UID -G sudo $NB_USER
#免密
RUN echo "jovyan  ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

#解析主机名
RUN echo "127.0.1.1 $(hostname)" >> /etc/hosts

USER $NB_USER

# Setup jovyan home directory
RUN mkdir $WORK_DIR && mkdir $USER_HOME/.local

#刷新库文件
RUN sudo ldconfig

WORKDIR $WORK_DIR

ADD consul $CONSUL_BIN
RUN sudo chmod +x $CONSUL_BIN && sudo chgrp $NB_USER $CONSUL_BIN && sudo chown $NB_USER $CONSUL_BIN

#创建consul的各种目录
RUN mkdir -p $CONSUL_DIR && mkdir -p $CONSUL_DIR/data && mkdir -p $CONSUL_DIR/config && mkdir -p $CONSUL_DIR/log && mkdir -p $CONSUL_DIR/scripts && mkdir -p $CONSUL_DIR/web

ADD consul.json $CONSUL_DIR/config/consul.json
RUN sudo chgrp $NB_USER $CONSUL_DIR/config/consul.json && sudo chown $NB_USER $CONSUL_DIR/config/consul.json

ADD consul.ini /etc/circus/conf.d/consul.ini

ADD start_consul.sh $WORK_DIR/start_consul.sh

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8500 8600 8600/udp

VOLUME $WORK_DIR

CMD sudo systemctl restart circusd

#保持运行状态
ADD idle.sh $WORK_DIR/idle.sh
CMD $SHELL $WORK_DIR/idle.sh






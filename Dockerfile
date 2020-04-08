FROM ubuntu:14.04

## Update repos
RUN apt-get update
RUN apt-get install -y wget curl git-core vim-common

## Install supervisor to herd the processes
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
# Keep the daemon in the foreground
RUN sed -i '/logfile=.*/ i\nodaemon=true'  /etc/supervisor/supervisord.conf

WORKDIR /opt/consul/
ADD consul /opt/consul/consul
ADD dist /opt/consul/dist
RUN ln -s /opt/consul/consul /usr/bin/consul
RUN mkdir -p /etc/consul.d
ADD etc/supervisor/conf.d/consul.conf /etc/supervisor/conf.d/consul.conf
ADD opt/qnib/bin /opt/qnib/bin
ADD etc/consul.json /etc/consul.json

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

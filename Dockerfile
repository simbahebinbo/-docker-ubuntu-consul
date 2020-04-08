FROM ubuntu:14.04

MAINTAINER "Christian Kniep <christian@qnib.org>

## Update repos
RUN apt-get update
RUN apt-get install -y wget curl git-core vim-common

## Install supervisor to herd the processes
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
# Keep the daemon in the foreground
RUN sed -i '/logfile=.*/ i\nodaemon=true'  /etc/supervisor/supervisord.conf

WORKDIR /opt/consul/
RUN apt-get install -y unzip
RUN wget -q https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip
RUN unzip 0.5.0_linux_amd64.zip;ln -s /opt/consul/consul /usr/bin/consul
RUN wget -q https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip
RUN unzip 0.5.0_web_ui.zip
RUN rm -f 0.5.0_linux_amd64.zip 0.5.0_web_ui.zip
RUN mkdir -p /etc/consul.d
ADD etc/supervisor/conf.d/consul.conf /etc/supervisor/conf.d/consul.conf
ADD opt/qnib/bin /opt/qnib/bin
ADD etc/consul.json /etc/consul.json

CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

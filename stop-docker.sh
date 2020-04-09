#!/bin/bash

#停掉所有正在运行的docker容器

docker ps -qa | docker stop `xargs` | docker rm `xargs`

#!/bin/bash

docker ps -qa | docker stop `xargs` | docker rm `xargs`


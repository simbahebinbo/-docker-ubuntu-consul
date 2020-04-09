#!/bin/bash

docker run --net=host -v $(pwd):/home/jovyan/work -h consul-consumer consul-consumer

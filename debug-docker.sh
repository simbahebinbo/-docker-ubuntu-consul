#!/bin/bash

docker exec -it $(docker ps -qa | head -1) /bin/bash


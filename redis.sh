#/bin/bash

docker run -d -p 6379:6379 --name="default_redis" redis:2.8.20 

#/bin/bash

docker run -d -p 9200:9200 -p 9300:9300 --name="default_elasticsearch" elasticsearch:1.5.2

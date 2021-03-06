#/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function run() {
    docker run -d -p 9200:9200 -p 9300:9300 --name="default_elasticsearch" -v "$DIR/config/elasticsearch":/usr/share/elasticsearch/config elasticsearch:2.1 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function stopContainer() {
    docker stop default_elasticsearch;
}

function restartContainer() {
    docker restart default_elasticsearch;
}

case "$1" in

"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_elasticsearch 2> /dev/null)
    if [ $? -eq 1 ]; then
        run;
    fi
 
    if [ "$RUNNING" == "true" ]; then
        echo "already running"
    fi

    if [ "$RUNNING" == "false" ]; then
        run;
    fi  
    ;;
"stop" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_elasticsearch 2> /dev/null)
    if [ $? -eq 1 ]; then
        echo "container not exist";
    fi
    
    if [ "$RUNNING" == "true" ]; then
         stopContainer;
    fi
    
    if [ "$RUNNING" == "false" ]; then
        echo "already stop";
    fi  

    ;;
* )
    echo "run, stop";
    ;;
esac
#docker run -d -p 3306:3306 --name="default_mysql" mysql:5.5.7

#/bin/bash

function run() {
    docker run -d -p 6379:6379 --name="default_mongo" mongo:3.1 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function stopContainer() {
    docker stop default_mongo;
}

function restartContainer() {
    docker restart default_mongo;
}

case "$1" in

"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mongo 2> /dev/null)
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
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mongo 2> /dev/null)
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

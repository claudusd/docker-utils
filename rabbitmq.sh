#/bin/bash

function run() {
    docker run -d -p 5672:5672 -p 15672:15672 --name="default_rabbitmq" rabbitmq:3.6.16-management 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;       
    fi  
}

function restartContainer() {
    docker restart default_rabbitmq;   
}

case "$1" in
"run") 
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_rabbitmq 2> /dev/null)
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
* )
    echo "run "
    ;;
esac

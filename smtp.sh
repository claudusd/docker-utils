#!/bin/bash

function run() {
    docker run -d -p 25:1025 -p 8025:8025 --name="default_smtp" mailhog/mailhog 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function restartContainer() {
    docker restart default_mysql;
}

case "$1" in
"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_smtp 2> /dev/null)
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
    echo "run";
    ;;
esac


#!/bin/bash

function run() {
    docker run -d -p 8026:80 --link default_mysql:db --name="default_phpmyadmin" phpmyadmin/phpmyadmin:4.6 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function restartContainer() {
    docker restart default_phpmyadmin;
}

case "$1" in
"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_phpmyadmin 2> /dev/null)
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
*)
    echo "run";
    ;;
esac

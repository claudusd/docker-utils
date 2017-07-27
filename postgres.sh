#/bin/bash

function run() {
    docker run -d -p 5432:5432 --name="default_postgres" -v data/postgres:/var/lib/postgresql/data/pgdata -e PGDATA=/var/lib/postgresql/data/pgdata -e POSTGRES_PASSWORD=itn -e POSTGRES_USER=root postgres:9.6.3 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function restartContainer() {
    docker restart default_postgres;
}
function listDatabases() {
    PGPASSWORD=itn psql -h 127.0.0.1 -U root -w -l
}

function createDatabase()   {
    if [ -z "$1" ]; then
        echo "Your must defined a database name";
        exit 0;
    fi

    PGPASSWORD=itn createdb -U root -h 127.0.0.1 -p 5432 -E UTF8 -e $1
}

case "$1" in
"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_postgres 2> /dev/null)
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
"create_database" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_postgres 2> /dev/null)
    if [ $? -eq 1 ]; then
        echo "do run";
    fi

    if [ "$RUNNING" == "true" ]; then
        createDatabase $2;
    fi

    if [ "$RUNNING" == "false" ]; then
        echo "do run";
    fi
;;
"list_databases" )
        RUNNING=$(docker inspect --format="{{ .State.Running }}" default_postgres 2> /dev/null)
        if [ $? -eq 1 ]; then
            echo "do run";
        fi

        if [ "$RUNNING" == "true" ]; then
           listDatabases;
        fi

        if [ "$RUNNING" == "false" ]; then
            echo "do run";
        fi
        ;;
* )
    echo "run, list_databases, create_database";
    ;;
esac

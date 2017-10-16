#/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function run() {
    docker run -d -p 3306:3306 --name="default_mysql" -v $DIR/data-mysql:/var/lib/mysql -v $DIR/mysql-config:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=itn mysql:5.7.11 2> /dev/null
    if [ $? -eq 1 ]; then
        restartContainer;
    fi
}

function stopContainer() {
    docker stop default_mysql;
}

function restartContainer() {
    docker restart default_mysql;
}

function createDatabase()   {
    if [ -z "$1" ]; then
        echo "Your must defined a database name";
        exit 0;
    fi
    
    if [ -z "$2" ]; then
        DATABASE_USER=$1;
        DATABASE_USER_PASSWORD=$1;
    else
        DATABASE_USER=$2;
        if [ -z "$3" ]; then
            DATABASE_USER_PASSWORD=$2;
       else 
            DATABASE_USER_PASSWORD=$3;
        fi
    fi
    
    read -r -d '' VARIABLE <<- EOM
CREATE DATABASE IF NOT EXISTS \`${1}\` ;
CREATE USER '$DATABASE_USER'@'%' IDENTIFIED BY '$DATABASE_USER_PASSWORD' ;
GRANT ALL ON \`${1}\`.* TO '$DATABASE_USER'@'%' ;
FLUSH PRIVILEGES ;
EOM

    docker exec -t default_mysql mysql -u root -pitn -e "$VARIABLE" 2> /dev/null
}

function listUsers() {
    docker exec -t default_mysql mysql -u root -pitn -e "select host, user from mysql.user;"     
}

function execScript() {
    name=$(cat $2) 
    docker exec -i -t  default_mysql mysql -u root -pitn -e "$name" $1
}

function listDatabases() {
    docker exec -t default_mysql mysql -u root -pitn -e "show databases;"
}

case "$1" in

"run" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
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
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
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
"create_database" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
    if [ $? -eq 1 ]; then
        echo "do run";
    fi

    if [ "$RUNNING" == "true" ]; then
        createDatabase $2 $3 $4;              
    fi

    if [ "$RUNNING" == "false" ]; then
        echo "do run";  
    fi
    ;;
"list_users" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
    if [ $? -eq 1 ]; then
        echo "do run";
    fi

    if [ "$RUNNING" == "true" ]; then
        listUsers;
    fi

    if [ "$RUNNING" == "false" ]; then
        echo "do run";
    fi
    ;;
"exec_script" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
    if [ $? -eq 1 ]; then
        echo "do run";
    fi
    
    if [ "$RUNNING" == "true" ]; then
        execScript $2 $3;
    fi
    
    if [ "$RUNNING" == "false" ]; then
        echo "do run";
    fi
    ;;
"list_databases" )
    RUNNING=$(docker inspect --format="{{ .State.Running }}" default_mysql 2> /dev/null)
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
    echo "run, stop, create_database, list_users, exec_script, list_databases";
    ;;
esac
#docker run -d -p 3306:3306 --name="default_mysql" mysql:5.5.7

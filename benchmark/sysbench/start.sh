#!/bin/bash


sudo yum install ob-sysbench -y
export PATH=/usr/local/sysbench/bin/:$PATH

host=$1
port=$2
#port=3306
user=$3
password=$4
db=$5


mysql -h${host} -u${user} -p${password} -P${port}  -e"drop database $db;"
mysql -h${host} -u${user} -p${password} -P${port}  -e"create database $db;"

    randomTypes=(
    "special"
    "uniform"
    "gaussian"
    "pareto"
    )
    for randomType in "${randomTypes[@]}"
    do
        echo "begin to run $randomType"
        tableSizes=(
        "1000000"
        )
        for tablesize in "${tableSizes[@]}"
        do
            date
            ./start-sysbench.sh $host $port $user $password $db $tablesize 100 $randomType
        done
    done


echo "Finish all tests"

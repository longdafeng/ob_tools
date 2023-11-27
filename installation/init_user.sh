#!/bin/bash

if [ $# -eq 0  ]; then
    USER = $USER

elif [ $# -eq 1 ]; then
        USER = $1
else
        echo "Useage: "
        echo "user: the user who will run oceanbase, default is $USER"
        exit 1
fi



echo "create user "
./sshs.sh useradd $USER
./sshs.sh passwd $USER

# This is for ocp 
./sshs.sh "echo '$USER  ALL=(ALL)       NOPASSWD: ALL ' >> /etc/sudoers"

echo "change user"
./sshs.sh mkdir -p /data/ob /clog/ob
./sshs.sh chown -R $USER /data
./sshs.sh chown -R $USER /clog

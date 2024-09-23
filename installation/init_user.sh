#!/bin/bash

NEW_USER=${USER}

if [ $# -eq 0  ]; then
    echo "User current user:" $USER
elif [ $# -eq 1 ]; then
        NEW_USER=$1
        echo "user:" $1
else
        echo "Useage: "
        echo "user: the user who will run oceanbase, default is $USER"
        exit 1
fi


echo "create user "
./sshs.sh useradd $NEW_USER
./sshs.sh passwd $NEW_USER

# This is for ocp
./sshs.sh "echo '$NEW_USER  ALL=(ALL)       NOPASSWD: ALL ' >> /etc/sudoers"

echo "change user"
./sshs.sh mkdir -p /data/ob /clog/ob
./sshs.sh chown -R $NEW_USER /data
./sshs.sh chown -R $NEW_USER /clog
                                

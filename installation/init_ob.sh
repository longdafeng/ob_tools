#!/bin/bash

ROOT_PWD=$1
OB_USER=admin

if [ $# -eq 1  ]; then
	
	OB_USER = admin

elif [ $# -eq 2 ]; then
        OB_USER = $2

else
        echo "Useage: "
        echo "ROOT_PWD: root password"
        echo "OB_USER: the user who will run OceanBase, default is admin"
        exit 1
fi


echo "begin to setup ssh "
./init_ssh.sh root $ROOT_PWD ./hosts 

echo "begin to init disks"
./init_disk.sh


echo "begin to create users"
./init_user.sh $OB_USER

echo "begin to setting system"
./init_sys.sh

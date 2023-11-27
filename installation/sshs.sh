#!/bin/bash


IPS=./hosts
USER=root

# ssh-keygen
for IP in $(cat $IPS)
  do
	echo "ssh " $IP $*
  	ssh $USER@$IP $*  
  done

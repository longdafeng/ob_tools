#!/bin/bash

echo "begin to fdisk"
./sshs.sh fdisk /dev/vdb
./sshs.sh fdisk /dev/vdc

echo "begin to mkfs"
./sshs.sh mkfs.ext4 /dev/vdb1
./sshs.sh mkfs.ext4 /dev/vdc1

echo "begin to mount"
./sshs.sh mkdir /data /clog
./sshs.sh "echo '/dev/vdb1 /clog ext4 defaults 0 0 ' >> /etc/fstab"
./sshs.sh "echo '/dev/vdc1 /data ext4 defaults 0 0 ' >> /etc/fstab"
./sshs.sh mount -a
./sshs.sh mount


./sshs.sh "echo '' >> /etc/sysctl.conf"
./sshs.sh "echo '# set oceanbase core dump data format' >> /etc/sysctl.conf"
./sshs.sh "echo 'kernel.core_pattern = /data/core-%e-%p-%t' >> /etc/sysctl.conf"

#!/bin/bash

echo "install software "
echo "install software mysql and python2, this is for ocp "
./sshs.sh "yum install -y mysql"
./sshs.sh "yum install -y python2"




echo "set system setting"

echo "set limits "
./sshs.sh "echo '' >>/etc/security/limits.conf"
./sshs.sh "echo 'root soft nofile 655350' >> /etc/security/limits.conf"
./sshs.sh "echo 'root hard nofile 655350' >> /etc/security/limits.conf"
./sshs.sh "echo '* soft nofile 655350' >> /etc/security/limits.conf"
./sshs.sh "echo '* hard nofile 655350' >> /etc/security/limits.conf"
./sshs.sh "echo '* soft stack 20480' >> /etc/security/limits.conf"
./sshs.sh "echo '* hard stack 20480' >> /etc/security/limits.conf"
./sshs.sh "echo '* soft nproc 655360' >> /etc/security/limits.conf"
./sshs.sh "echo '* hard nproc 655360' >> /etc/security/limits.conf"
./sshs.sh "echo '* soft core unlimited' >> /etc/security/limits.conf"
./sshs.sh "echo '* hard core unlimited' >> /etc/security/limits.conf"



echo "setting /etc/sysctl.conf"
# all setting please refer to https://www.oceanbase.com/docs/common-ocp-1000000000348013
./sshs.sh "echo '' >> /etc/sysctl.conf"
./sshs.sh "echo '# for oceanbase' >> /etc/sysctl.conf"

./sshs.sh "echo '## tunning memory, this is very important for oceanbase' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.swappiness = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.max_map_count = 655360' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.min_free_kbytes = 2097152' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.overcommit_memory = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.nr_hugepages = 0' >> /etc/sysctl.conf"



./sshs.sh "echo '' >> /etc/sysctl.conf"
./sshs.sh "echo '## tunning network' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.somaxconn = 2048' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.netdev_max_backlog = 10000' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.rmem_default = 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.wmem_default = 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo '' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.ip_local_port_range = 13500 65535' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.ip_forward = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.conf.default.rp_filter = 1' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.conf.default.accept_source_route = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_rmem = 4096 87380 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_max_syn_backlog = 16384' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_fin_timeout = 15' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_max_syn_backlog = 16384' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_tw_reuse = 1' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_tw_recycle = 1' >> /etc/sysctl.conf"
./sshs.sh "echo 'net.ipv4.tcp_slow_start_after_idle=0' >> /etc/sysctl.conf"


./sshs.sh "echo '## setting kernel ' >> /etc/sysctl.conf"
./sshs.sh "echo 'fs.aio-max-nr=1048576' >> /etc/sysctl.conf"
./sshs.sh "echo 'kernel.numa_balancing = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'vm.zone_reclaim_mode = 0' >> /etc/sysctl.conf"
./sshs.sh "echo 'fs.file-max = 6573688' >> /etc/sysctl.conf"
./sshs.sh "echo 'fs.pipe-user-pages-soft = 0' >> /etc/sysctl.conf"

./sshs.sh "sysctl -p"

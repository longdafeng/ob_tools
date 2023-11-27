#!/bin/bash


host=$1
port=$2
user=$3
password=$4
db=$5

tableSize=$6
tableNum=$7
randomType=$8



echo "Begin to test sysbench on " ${tableSize} " *  " ${tableNum}  " random type " ${randomType}

date

echo "oltp_read_only prepare"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} prepare

echo "oltp_read_only threads: 16"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=16 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_only threads: 64"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=64 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_only threads: 256"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=256 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_only threads: 512"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=512 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_only threads: 1024"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=1024 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_only threads: 16, transaction is off"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=16 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --skip_trx=on --db-ps-mode=disable run

echo "oltp_read_only threads: 64, transaction is off"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=64 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --skip_trx=on --db-ps-mode=disable run

echo "oltp_read_only threads: 256, transaction is off"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=256 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --skip_trx=on --db-ps-mode=disable run

echo "oltp_read_only threads: 512, transaction is off"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=512 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --skip_trx=on --db-ps-mode=disable run

echo "oltp_read_only threads: 1024, transaction is off"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=1024 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --skip_trx=on --db-ps-mode=disable run

echo "oltp_read_only cleanup"
sysbench oltp_read_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} cleanup


date
echo "Begin to test sysbench on " ${tableSize} " *  " ${tableNum}  " random type " ${randomType}
echo "oltp_write_only prepare"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} prepare

echo "oltp_write_only threads: 16"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=16 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_write_only threads: 64"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=64 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_write_only threads: 256"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=256 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_write_only threads: 512"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=512 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run
echo "oltp_write_only threads: 1024"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=1024 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_write_only cleanup"
sysbench oltp_write_only --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} cleanup



date
echo "Begin to test sysbench on " ${tableSize} " *  " ${tableNum}  " random type " ${randomType}
echo "oltp_read_write prepare"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} prepare

echo "oltp_read_write run threads : 16"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=16 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_write run threads : 64"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=64 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_write run threads : 256"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=256 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_write run threads : 512"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=512 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_write run threads : 1024"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=1024 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} --db-ps-mode=disable run

echo "oltp_read_write cleanup"
sysbench oltp_read_write --mysql-host=${host} --mysql-port=${port} --mysql-db=${db} --mysql-user=${user} --mysql-password=${password} --table_size=${tableSize} --tables=${tableNum} --threads=100 --events=0 --time=240 --report_interval=60 --percentile=95  --rand-type=${randomType} cleanup

date
echo "Begin to test sysbench on " ${tableSize} " *  " ${tableNum}  " random type " ${randomType}
echo "Finish one loop tests"

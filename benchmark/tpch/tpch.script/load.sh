#!/usr/bin/bash

host=$1
port=$2
user=$3
password=$4
db=$5
data_dir=$6
target=$7
extra_setting=""
if [ $# -eq 8 ]; then
        extra_setting=$8
        echo "Extra index will be used :" $extra_setting
fi

if [ "$extra_setting" = "" ]; then

else

        mysql -h${host} -u${user} -p${password} -P${port}  < $extra_setting
fi
        
extra_index=""
if [ $# -eq 9 ]; then
        extra_index=$9
        echo "Extra index will be used :" $extra_index
fi

echo "@@@@@@@@@@@@@@ step 1: create database @@@@@@@@@@@@@@@@@@@"
date
mysql -h${host} -u${user} -p${password} -P${port}  -e"drop database $db;"
mysql -h${host} -u${user} -p${password} -P${port}  -e"create database $db;"
echo "@@@@@@@@@@@@@ step 2.1: create table @@@@@@@@@@@@@@@"
date
cd ${target}
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} < dss.ddl

echo "@@@@@@@@@@@@ step 2.2: create key @@@@@@@@@@@@@@@@"
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} < dss.ri
cd ..

# This is only for polardb



echo "@@@@@@@@@@@@@@@ step 3: load data @@@@@@@@@@@@@@@@@"
cd ${data_dir}
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'customer.tbl' into table customer FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"  
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'nation.tbl' into table nation FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"  
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'orders.tbl' into table orders FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"  
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'partsupp.tbl' into table partsupp FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"  
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'part.tbl' into table part FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';" 
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'region.tbl' into table region FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';" 
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'supplier.tbl' into table supplier FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';" 
date
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0;load data local infile 'lineitem.tbl' into table lineitem FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';" 


date
cd "../"

# support split raw.tbl file into raw.1.tbl, raw.2.tbl, raw.x.tbl
# please use split -l xxxx xxx

#for file in $(ls *.tbl); 
#   do 
#       echo "load data local infile '${file}' into table ${file%.tbl} FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"
#       mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"SET FOREIGN_KEY_CHECKS=0,UNIQUE_CHECKS=0,AUTOCOMMIT=0;load data local infile '${file}' into table ${file%.tbl} FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';" &
#       sleep 1
#done
#
#echo "step 3: load data"
#date
#
#while true
#do
#        count=`ps aux | grep mysql | grep infile | grep -v "grep" | wc -l`
#        if [ $count -gt 0 ];then
#                
#                process=`ps aux | grep mysql | grep load | grep -v grep`
#                echo $process
#                sleep 10
#        else
#                echo "Finish load all data!!!"
#                break 
#        fi        
#done


date
echo "@@@@@@@@@@@@@@@ Create extra index. @@@@@@@@@@@@@@@@@"
if [ "$extra_index" = "" ]; then

        echo "step 4 skip create extra index"
else
        
        echo "step 4 begin to create index"
        $extra_index ${host} ${port} ${user} ${password}  ${db}
fi

date
echo "@@@@@@@@@@@@@@ analyze tables @@@@@@@@@@@@@@@@@@@@@"
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE table CUSTOMER ;" 
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE table LINEITEM ;"
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE TABLE NATION ;"
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE TABLE ORDERS ;"
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE TABLE PART ; "
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE TABLE PARTSUPP ;" 
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE  TABLE  REGION ;" 
mysql -h${host} -u${user} -p${password} -P${port}  -D${db} -e"ANALYZE  TABLE SUPPLIER;" 
date 
echo "finish"

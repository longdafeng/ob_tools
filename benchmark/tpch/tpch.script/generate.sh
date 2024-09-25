#!/usr/bin/bash

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"


cd ../tpch-kit/dbgen

echo "@@@@@@@@@@@@ Step1: Begin to make @@@@@@@@@@@"

make


echo "@@@@@@@@@@@@ Step2: Begin to generate testing data @@@@@@@@@@@"

./dbgen -s 100
mkdir tpch100
mv *.tbl tpch100

mv tpch100 $CURRENT_DIR



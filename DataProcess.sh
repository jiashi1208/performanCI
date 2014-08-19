#!/bin/sh
php CompareData_no_op.php

awk -F "=" -f DataStatistics.awk config.txt Result_reference.txt

sleep 5

cat url.txt |while read line
do
  curl  $line
  sleep 2
done
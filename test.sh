#!/bin/sh
#process totalResult.csv
php CompareData_no_op.php

#process config.txt,make sure which data is fail,which data is pass
awk -F "=" -f DataStatistics.awk config.txt Result_reference.txt

sleep 3

#estimate summary info
if [ -f error.txt ]
  then
    echo "test fail.make error file"
    test_result="fail"
    while read line  
    do  
      describe+="|"$line
    done <error.txt 
 else
  echo "test pass"
  test_result="pass"
  describe="test_pass_everyvalue_correct"
fi
url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformance&version=7.4.0&testname=describetestitem&testresult="$test_result"&fromplatform=android&timestamp=201408121446&runtime=201408121448&describe="$describe"&vertime=20140814"
echo $url >>url.txt

#send http request
cat url.txt |while read line
do
 curl  $line
 sleep 2
done
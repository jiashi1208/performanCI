#!/bin/sh
#process totalResult.csv
date=$1
version=$2
vertime=$3

php CompareData_no_op.php

cp config.txt $date
cp Result_reference.txt $date
rm config.txt

#process config.txt,make sure which data is fail,which data is pass
cd $date
awk -v version="$version" -v vertime="$vertime" -v date="$date" -F "=" -f ../DataStatistics.awk config.txt Result_reference.txt

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
#no runtime
url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformance&version="$version"&testname=android_performance_test&testresult="$test_result"&fromplatform=android&timestamp="$date"&runtime=201408121448&describe="$describe"&vertime="$vertime
echo $url >>url.txt

#send http request
cat url.txt |while read line
do
 curl  $line
 sleep 2
done

cd ..
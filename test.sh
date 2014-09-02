#!/bin/sh
#process totalResult.csv

#url encode function
function urlEncode(){
echo ${1} | od -t x |awk '{
    w=split($0,linedata," ");
    for (j=2;j<w+1;j++)
    {
        for (i=7;i>0;i=i-2)
        {
            if (substr(linedata[j],i,2) != "00") {printf "%%" ;printf toupper(substr(linedata[j],i,2));}

        }
    }
}'
}


. ./config
mbinfo=$mbinfo
#对其进行编码
echo "编码前" $mbinfo
mbinfo=$(urlEncode  $mbinfo);

echo $mbinfo
echo $consumetime

date=$1
version=$2
vertime=$3
#mkdir $date

php CompareData.php

cp config.txt $date
cp Result_reference.txt $date
rm config.txt

#if [ 1 -eq 2 ]; then 
#process config.txt,make sure which data is fail,which data is pass
cd $date
awk -v version="$version" -v vertime="$vertime" -v date="$date" -F "=" -f ../DataStatistics2.awk config.txt Result_reference.txt

sleep 3

#fi

#estimate summary info
if [ -f error.txt ]
  then
    echo "test fail.make error file"
    test_result="fail"
    while read line  
    do  
      describe+=$line"</br>"
    done <error.txt 
 else
  echo "test pass"
  test_result="pass"
  describe="测试通过！每项数据都测试完成,且数据都在合理范围内变化."
fi
#no runtime
url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&mbinfo="$mbinfo"&testname=android_performance_test&testresult="$test_result"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe"&vertime="$vertime
echo $url >>url.txt

#对字符串进行编码
while read line
do
  a=$( expr $line : '.*&describe=\(.*\)&vertime' )
  b=$(urlEncode  $a);
  line2=${line//"$a"/"$b"}
  echo $line2 >>new_url.txt
 
done <url.txt

#send http request
#if [ 1 -eq 2 ];then 
cat new_url.txt |while read line
do
 curl  "$line"
 sleep 2
done

#fi
cd ..



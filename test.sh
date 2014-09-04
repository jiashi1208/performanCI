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

#process config.txt,make sure which data is fail,which data is pass
cd $date
awk -v version="$version" -v vertime="$vertime" -v date="$date" -F "=" -f ../DataStatistics2.awk config.txt Result_reference.txt
sleep 3

#fromplatform="性能自动化运行"

#分析error文件，归类存放
awk -f ../outline.awk error.txt

#分析各个文件
if  [ -f search.txt ]
   then
   test_result_search="fail"
   describe_search="搜索数据异常,具体如下:"
    while read line  
    do  
      describe_search+=$line"</br>"
    done <search.txt
   
    echo "describe_search "$describe_search
    url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=SearchTimeResult&testresult="$test_result_search"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_search"&vertime="$vertime
    echo $url >>url.txt
   else
   
     test_result_search="pass"
     describe_search="搜索测试通过！每项数据都测试完成,且数据都在合理范围内变化."
	 
	 url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=SearchTimeResult&testresult="$test_result_search"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_search"&vertime="$vertime
     echo $url >>url.txt

fi

if  [ -f cpu.txt ]
   then
   test_result_cpu="fail"
   describe_cpu="CPU数据异常,具体如下:"
    while read line  
    do  
      describe_cpu+=$line"</br>"
    done <cpu.txt
   
    url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=CpuAvr&testresult="$test_result_cpu"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_cpu"&vertime="$vertime
    echo $url >>url.txt
   else
   
     test_result_cpu="pass"
     describe_cpu="搜索测试通过！每项数据都测试完成,且数据都在合理范围内变化."
	 
	 url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=CpuAvr&testresult="$test_result_cpu"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_cpu"&vertime="$vertime
     echo $url >>url.txt

fi

if  [ -f memory.txt ]
   then
   test_result_mem="fail"
   describe_mem="内存测试数据异常,具体如下:"
    while read line  
    do  
      describe_mem+=$line"</br>"
    done <memory.txt
   
    url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=MemAvr&testresult="$test_result_mem"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_mem"&vertime="$vertime
    echo $url >>url.txt
   else
   
     test_result_mem="pass"
     describe_mem="内存测试通过！每项数据都测试完成,且数据都在合理范围内变化."
	 
	 url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=MemAvr&testresult="$test_result_mem"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_mem"&vertime="$vertime
     echo $url >>url.txt

fi

if  [ -f starttime.txt ]
   then
   test_result_starttime="fail"
   describe_starttime="启动时间异常,具体如下:"
    while read line
    do  
      describe_starttime+=$line"</br>"
    done <starttime.txt
   
    url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=StartTime&testresult="$test_result_starttime"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_starttime"&vertime="$vertime
    echo $url >>url.txt
   else
   
     test_result_starttime="pass"
     describe_starttime="启动时间测试通过!每项数据都测试完成,且数据都在合理范围内变化."
	 
	 url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=StartTime&testresult="$test_result_starttime"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe_starttime"&vertime="$vertime
     echo $url >>url.txt

fi




#estimate summary info
#if [ -f error.txt ]
#  then
 #   echo "test fail.make error file"
 #   test_result="fail"
  #  while read line  
 #   do  
 #     describe+=$line"</br>"
  #  done <error.txt 
# else
 # echo "test pass"
 # test_result="pass"
 # describe="测试通过！每项数据都测试完成,且数据都在合理范围内变化."
#fi
#no runtime
#url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformance&version="$version"&consumetime=8h30m&fromplatform=性能自动化运行&mbinfo="$mbinfo"&testname=android_performance_test&testresult="$test_result"&fromplatform=android&timestamp="$date"&runtime="$date"&describe="$describe"&vertime="$vertime
#echo $url >>url.txt

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



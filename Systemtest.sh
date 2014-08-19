#!/bin/sh
# sh test.sh  majingting 10
function background() {
  echo "bg test"
	{       
		file="/sdcard/zfy/0.txt"
		adb -s $1 shell rm ${file}
		while true; do
			tmp=`adb -s $1 shell ls ${file} | grep -v "No such"`
			echo "tmp:${tmp}"

			if  [ -z $tmp ]; then
				echo "waiting bg test setting"
			else
				break;
			fi

			sleep 1
		done

		sleep 5
	echo "press home button"
	adb -s $1 shell input keyevent 3
	}&

	adb -s $1 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#test_System_Background -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
	sleep 10
	adb -s $1 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
}

function foreground() {
  echo "fg test"
	adb -s $1 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#test_System_Foreground -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
	sleep 10
	adb -s $1 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

}

function operate() {
   echo "op test"
	 adb -s $1 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#test_System_Operate -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
	sleep 10
	 adb -s $1 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

}


# sh test.sh  majingting 10 device1(systemdevice) device2(searchdevice) date
function proc (){
echo "BaiduMap Perfprmance Test proc"
name=$1
num=$2
device1=$3
device2=$4
date=$5
tmp=0
tmp1=0
tmp2=0

echo "make data dir"
mkdir $date

echo "commit ctsjob to musi"
curl -d "appurl=http://10.81.12.242:8789/apksfordaily/release/BaiduMap-release.apk&email=shijia@baidu.com,caoxiurong@baidu.com&testtype=full"  http://musi.baidu.com/?r=BqsAjax/SubmitCITask

echo "delete old BaiduMap apk"
rm package/Baidu*

echo "wget new BaiduMap apk"
wget -P package http://10.81.12.242:8789/apksfordaily/release/BaiduMap-release.apk

echo "bak  baiduapk to bakdir"

newName="BaiduMap-release"$date".apk"
cp package/BaiduMap-release.apk  $date/$newName

echo "delete old data from pc && mobile"
rm TotalResult.csv
rm data/data.zip



adb -s $device1 shell rm -r /sdcard/autotester/sysperf/*
adb -s $device1 shell rm -r /sdcard/autotester/searchperf/*
adb -s $device1 shell rm -r /sdcard/autotester/result/*
adb -s $device2 shell rm -r /sdcard/autotester/sysperf/*
adb -s $device2 shell rm -r /sdcard/autotester/searchperf/*
adb -s $device2 shell rm -r /sdcard/autotester/result/*


echo "uninstall device1"
{
sleep 10
adb -s $device1 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#init
}&
adb -s $device1  uninstall com.baidu.BaiduMap

sleep 15

echo "install device1 "
{
sleep 10
adb -s $device1 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#init
}&
adb -s $device1 install package/BaiduMap-release.apk

sleep 15


echo "uninstall device2"
{
sleep 10
adb -s $device2 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#init
}&
adb -s $device2  uninstall com.baidu.BaiduMap

sleep 15

echo "install device2"
{
sleep 10
adb -s $device2 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#init
}&
adb -s $device2 install package/BaiduMap-release.apk

sleep 15



#echo "install BaiduMap on the first device"
#{
#echo "touch install button by monkey on the first device"
#sleep 20
#adb -s $device1 shell monkey -f "/sdcard/AutoTester/monkey.script" 1
#}&
#adb -s $device1 install package/BaiduMap-release.apk

#sleep 20


#echo "install BaiduMap in the second device"
#{
#sleep 20
#echo "touch install button by monkey on the second device"
#adb -s $device2 shell monkey -f "/sdcard/AutoTester/monkey.script" 1
#}&
#adb -s $device2 install package/BaiduMap-release.apk


#sleep 20


{
  echo "thread2 search test"
  adb -s $device2 shell am instrument -e class com.baidu.map.perftest.BatteryTestPerf_V630\#prepareForTestMI2 -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner


	adb -s $device2 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#test_Search -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
	sleep 10
	adb -s $device2 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

	
	sleep 10
	
	adb -s $device2 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#dealSearchResult -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
	sleep 10
	adb -s $device2 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

	
	sleep 10
	
  mkdir "E:/xingneng/$date"
  sleep 5
  mkdir "E:/xingneng/$date/SearchPerf"

  sleep 2

  adb -s $device2 pull "/sdcard/AutoTester/SearchPerf" "E:\\xingneng\\$date\\SearchPerf"

  sleep 5
  
  echo "finish search test"
  
}&


echo "thread1 bg fg op test"
adb -s $device1 shell am instrument -e class com.baidu.map.perftest.BatteryTestPerf_V630\#prepareForTestMI2 -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

echo "start start time test"
sh looptesttime.sh  $name 20 3 $device1

echo "finish start time test"
sleep 10

echo "start bg fg op test"
while [ $tmp -lt $num ] ; do
echo "bg test $tmp"
	background $device1
	sleep 5
	tmp=$(($tmp+1))
done

while [ $tmp1 -lt $num ] ; do
echo "fg test $tmp1"
	foreground $device1
	sleep 5
	tmp1=$(($tmp1+1))
done

#while [ $tmp2 -lt $num ] ; do
#echo "op test $tmp2"
#	operate $device1
#	sleep 5
#	tmp2=$(($tmp2+1))
#done

sleep 5

adb -s $device1 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#dealSysResult -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

sleep 5

mkdir "E:/xingneng/$date"
mkdir "E:/xingneng/$date/SysPerf"

mv time_*.csv E:/xingneng/$date

adb -s $device1 pull "/sdcard/AutoTester/SysPerf" "E:\\xingneng\\$date\\SysPerf"

sleep 5

adb -s $device1 pull "/sdcard/AutoTester/result" "E:\\xingneng\\$date\\SysPerf"

sleep 5

path="E:/xingneng/$date/SearchPerf"
 while true ; do
    if [ -d "$path" ]; then
      echo "Success!finish test"
			break;
		else
		  echo "not finish performance test,waiting"
			sleep 10
			
		fi
  done
}

StartTime=`date +"%Y-%m-%d %H:%M:%S"`
mStartTime=`date -d  "$StartTime" +%s`
proc $1 $2 $3 $4 $5
EndTime=`date +"%Y-%m-%d %H:%M:%S"`
mEndTime=`date -d  "$EndTime" +%s`

interval=`expr $mEndTime - $mStartTime` 
echo interval >"interval.txt"
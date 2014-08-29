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
if [ 1 -eq 2 ]; then
echo "make pc local diretory "$date" and data for put test data"
mkdir -p $date/data

echo "commit ctsjob to musi"
curl -d "appurl=http://10.81.12.242:8789/apksfordaily/release/BaiduMap-release.apk&email=shijia@baidu.com,caoxiurong@baidu.com&testtype=full"  http://musi.baidu.com/?r=BqsAjax/SubmitCITask


echo "wget new BaiduMap apk"
wget -P $date http://10.81.12.242:8789/apksfordaily/release/BaiduMap-release.apk

echo "rename BaiduMap with date"
newNameAPK="BaiduMap-release"$date".apk"
mv $date/BaiduMap-release.apk  $date/$newNameAPK


echo "detect whether there is two mobile phone"
#adb devices|grep device$ >./$date/device.txt


echo "uninstall device1"
{
adb -s $device1  uninstall com.baidu.BaiduMap
}&
sleep 15
adb -s $device1 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#cancel

sleep 5
echo "install device1 "
{
adb -s $device1 install $date/$newNameAPK
}&
sleep 15
adb -s $device1 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#install
sleep 5

echo "uninstall device2"
{
adb -s $device2  uninstall com.baidu.BaiduMap
}&
sleep 15
adb -s $device2 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#cancel
sleep 5

echo "install device2"
{
adb -s $device2 install $date/$newNameAPK
}&
sleep 15
adb -s $device2 shell uiautomator runtest installscript.jar -c com.baidu.baidumap.initenviron.StartApp#install

sleep 20

{
  echo "device2 for  search test"
  
  adb -s $device2 shell rm -r /sdcard/autotester/searchperf/*
  adb -s $device2 shell rm -r /sdcard/autotester/result/*
  
  adb -s $device2 shell am instrument -e class com.baidu.map.perftest.BatteryTestPerf_V630\#prepareForTestMI2 -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner


  adb -s $device2 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#test_Search -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
  sleep 10
	
  adb -s $device2 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
  sleep 10
	
  adb -s $device2 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#dealSearchResult -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
  sleep 10
	
  adb -s $device2 shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\#test_emptytest -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
  sleep 10

  echo "search test finish,and start to deal data"
  sleep 5
  mkdir -p  ./$date/SearchPerf
  sleep 2

  adb -s $device2 pull "/sdcard/AutoTester/SearchPerf" "./$date/SearchPerf"
  sleep 5
  echo "finish search test"
  
}&

p1=$!

{
  echo "device 1  for bg fg op test"
 
  adb -s $device1 shell rm -r /sdcard/autotester/searchperf/*
  adb -s $device1 shell rm -r /sdcard/autotester/result/*

  adb -s $device1 shell am instrument -e class com.baidu.map.perftest.BatteryTestPerf_V630\#prepareForTestMI2 -w com.baidu.map.perftest/com.zutubi.android.junitreport.JUnitReportTestRunner
  echo "start start time test"
  cd $date
  sh ../looptesttime.sh  $name 20 3 $device1

  echo "finish start time test"
  sleep 10

  cd ..

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

  while [ $tmp2 -lt $num ] ; do
  echo "op test $tmp2"
	operate $device1
	sleep 5
	tmp2=$(($tmp2+1))
  done

  sleep 5

  echo "start time,fg,bg,op finish test,deal with data,pull data to directory"
  adb -s $device1 shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\#dealSysResult -w com.baidu.BaiduMap.Perftest/com.zutubi.android.junitreport.JUnitReportTestRunner

  sleep 5

  mkdir -p ./$date/SysPerf
  mv time_*.csv ./$date

  adb -s $device1 pull "/sdcard/AutoTester/SysPerf" "./$date/SysPerf"

  sleep 5

  adb -s $device1 pull "/sdcard/AutoTester/result" "./$date/SysPerf"

  sleep 5
  echo "finish op ,fg,bg test"
}&
  p2=$!

  wait p1 && wait p2
  
fi

  echo   "Success! Finish test" 
  
  echo "deal with data from test data"
  java -jar dataproc.jar $date
  cp $date/TotalResult.csv .
  
  echo "zip test data" 
  tar -czf $date/all.tar.gz $date/data
}

proc $1 $2 $3 $4 $5
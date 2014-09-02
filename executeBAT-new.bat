@Rem set ymd=%date:~,4%%date:~5,2%%date:~8,2%

set hour=%time:~0,2%
set hour=%hour: =0%
set ymd=%date:~0,4%%date:~5,2%%date:~8,2%%hour%%time:~3,2%%time:~6,2%

@Rem performance test mobile device1 for bg fg op. device2 for  search
@Rem search test mobile device2

set device1=f0bc0450
set device2=20454757
echo %device1%
echo %device2%
echo %ymd%

if "%VERSION%"=="" ( set VERSION=7.0.0 ) else ( echo VERSION:%VERSION% )
if "%VER_TIME%"=="" ( set VER_TIME=20140000 ) else ( echo VER_TIME:%VER_TIME% )


del TotalResult.csv

C:\cygwin\bin\sh.exe Systemtest-new.sh performance_test 8 %device1% %device2% %ymd%

@Rem process data
C:\cygwin\bin\sh.exe test.sh %ymd% %VERSION% %VER_TIME%
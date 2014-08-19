@Rem set ymd=%date:~,4%%date:~5,2%%date:~8,2%

set hour=%time:~0,2%
set hour=%hour: =0%
set ymd=%date:~0,4%%date:~5,2%%date:~8,2%%hour%%time:~3,2%%time:~6,2%

@Rem performance test mobile device1 GTI9300 4df7e601434ccf6d
@Rem search test mobile device2

set device1=f0bc0450
set device2=20454757
echo %device1%
echo %device2%
echo %ymd%

del TotalResult.csv

C:\cygwin\bin\sh.exe Systemtest.sh performance_test 8 %device1% %device2% %ymd%


java -jar .\DealResult.jar %ymd%
cp E:\xingneng\%ymd%\TotalResult.csv  .


"C:\Program Files\WinRAR\Rar.exe" a E:\xingneng\%ymd%.zip E:\xingneng\%ymd%
cp E:\xingneng\%ymd%.zip  .\data\data.zip

echo "bak data"
cp data/data.zip %ymd%
cp TotalResult.csv %ymd%

@Rem process data
C:\cygwin\bin\sh.exe DataProcess.sh
BEGIN{
print "version "version
print "vertime "vertime
print "date "date
}
{
if(ARGIND==1) {array1[$1]=$2}
if(ARGIND==2) {array2[$1]=$2}
k=0;
}
END{
 
   for(key in array1){
      i=index(tolower(key),"max")
	  j=index(tolower(key),"power")
	  k=index(tolower(key),"net")
	  
	  if(i!=0 ||j!=0||k!=0){
	  
	     #排除比较电量，网络，最高速度等。
	     test_result="pass"
	     describe=key"数据正常"
	  
	  }else {
	  
	    #没有值，为-1
	    if(match(array1[key],"-1.00")||match(array1[key],"-1")){
		  test_result="fail"
	      describe=key"数据为空" 
		  summary=key"数据为空;"
		  print summary > "error.txt"
		  
		  url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformanceDetail&version="version"&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp="date"&describe="describe"&vertime="vertime
	      print url > "url.txt"
		  continue
		}
		if(compare(array1[key],array2[key])==1){
		
		 test_result="pass"
	     describe="data_is_ok"
		
		}else if(compare(array1[key],array2[key])==0){
		
		 test_result="fail"
	     describe=key"数据不正常,变化幅度超过标准值20%"
		 summary=key"数据不正常,变化幅度超过标准值20%;"
		 print summary > "error.txt"
		}
	  }
	  
	  url="http://180.149.144.140/ci/DataProcess.php?act=insert_CIPerformanceDetail&version="version"&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp="date"&describe="describe"&vertime="vertime
	  print url > "url.txt"
 
   }

 }

function compare(value1,value2){

   v1=value1+0;
   v2=value2+0;
   
   if(v2!=0){
   diff=v1-v2
   diff_percent=diff/v2
   diff_percent=diff_percent*100
   if(diff_percent<-20 || diff_percent>20)
     { 
	  return 0
	  }
  else{
      return 1
	  }
	}else {
	return 1
}
}
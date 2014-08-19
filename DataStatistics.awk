{
if(ARGIND==1) {array1[$1]=$2}
if(ARGIND==2) {array2[$1]=$2}
k=0;
}
END{
  for(key in array1){

		
		i=index(tolower(key),"max")
		if(i==0){
			
		
    if(compare(array1[key],array2[key])==1){
	  test_result="pass"
	  describe="data_is_ok"
	  
	  #url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformanceDetail&version=7.2.5&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp=201408161458&describe="describe"&vertime=20140818"
	  #print url > "url.txt"
	  
	}else if(compare(array1[key],array2[key])==0){
		
	  testresult="fail"
	  describe="data_unnormal_far_away_from_standard"
	  
	  #url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformanceDetail&version=7.2.5&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp=201408161458&describe="describe"&vertime=20140818"
	  #print url > "url.txt"
	}
	
}
else{
	test_result="pass"
	describe="data_is_ok"
	
	#url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformanceDetail&version=7.2.5&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp=201408161458&describe="describe"&vertime=20140818"
	#print url > "url.txt"
	
	}
	
	url="http://10.95.36.21:8151/utest/lijie/ci/index2.php?act=insert_CIPerformanceDetail&version=7.2.5&testname="key"&testitem="key"&testdata="array1[key]"&testresult="test_result"&testdetail=describetestdetail&timestamp=201408161458&describe="describe"&vertime=20140818"
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
   if(diff_percent<-20 && diff_percent>20)
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
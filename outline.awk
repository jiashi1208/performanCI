BEGIN{
 i=0
}
{
i++
array[i]=$1
}
END{
  #print length(array)
 
  for(j=0;j<length(array);j++){
  print array[1]
  print  index(tolower(array[1]),"search")

  if(index(tolower(array[i]),"search")!=0){
    
	print 333
    print array[i]> "search.txt"
  
  }else if(index(tolower(array[i]),"cpu")){
  
    print cpu
    print array[i]> "cpu.txt"
  
  }else if(index(tolower(array[i]),"mem")){
    
	print mem
    print array[i]> "memeory.txt"
    
  }else if(index(tolower(array[i]),"starttime")){
  
    print time
    print array[i]> "starttime.txt"
  }else{
     print 333
  }

}
}
BEGIN{
 i=0
}
{
i++
array[i]=$1
}
END{
 
  print length(array)
  for(j=0;j<length(array);j++){
  
   print j
  # print index(tolower(array[j]),"search")
    
  if(index(tolower(array[j]),"search")!=0){

    print array[j]> "search.txt"
  
  }else if(index(tolower(array[j]),"cpu")!=0){
  
    print array[j]> "cpu.txt"
  
  }else if(index(tolower(array[j]),"mem")!=0){
    
    print array[j]> "memory.txt"
    
  }else if(index(tolower(array[j]),"starttime")!=0){
  
    print array[j]> "starttime.txt"
  }else{
     print 333
  }
}
}
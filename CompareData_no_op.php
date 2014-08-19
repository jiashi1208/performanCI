<?php
    
//    文件路径
    $SourcePath="TotalResult.csv";
    $OutputPath="/Users/shoujiditu/Desktop/compareSendMail";
//    此处是bg数据获取序列
    $bgArrayItem=Array("bgCpuMax","bgCpuAvr","bgMemMax","bgMemAvr","bgNetIn","bgNetOut","bgCpuPower","bgGpsPower","bgTotalPower");
//    同上 fg
    $fgArrayItem=Array("fgCpuMax","fgCpuAvr","fgMemMax","fgMemAvr","fgNetIn","fgNetOut","fgCpuPower","fgGpsPower","fgTotalPower");
//    同上 OP
    $opArrayItem=Array("opCpuMax","opCpuAvr","opMemMax","opMemAvr","opNetIn","opNetOut","opCpuPower","opGpsPower","opTotalPower");
//    同上 检索时间
$SearchTimeArrayItem=Array("sigSearchTimeResult","mulSearchTimeResult","busSearchTimeResult","carSearchTimeResult","footSearchTimeResult","generalSearchTimeResult","NearbySearchTimeResult","GeoSearchTimeResult","sugSearchTimeResult");
//    同上 检索上行数据量
$SearchTimeUploadArrayItem=Array("sigSearchTimeResultUpload","mulSearchTimeResultUpload","busSearchTimeResultUpload","carSearchTimeResultUpload","footSearchTimeResultUpload","generalSearchTimeResultUpload","NearbySearchTimeResultUpload","GeoSearchTimeResultUpload","sugSearchTimeResultUpload");
//    同上 检索下行数据量
$SearchTimeDownloadArrayItem=Array("sigSearchTimeResultDownload","mulSearchTimeResultDownload","busSearchTimeResultDownload","carSearchTimeResultDownload","footSearchTimeResultDownload","generalSearchTimeResultDownload","NearbySearchTimeResultDownload","GeoSearchTimeResultDownload","sugSearchTimeResultDownload");
    
//    获取total中的数据
    $file = fopen($SourcePath,"r");
    while ($data = fgetcsv($file)) { //每次读取CSV里面的一行内容
//  $goods_list中就是所有这个csv中的数据
        $goods_list[] = $data;
    }
    
//  print_r($goods_list);
//  此为统一定义的回车
    $huiche="\n";

    fclose($file);
//    以下为对数据的处理
    
//    启动时间   begin
    $StartTimeO=$goods_list[0][0];
    $arr=explode('---', $StartTimeO);
    $StartTime=$arr[1];

//  echo "StartTime:".$StartTime;
//  echo $huiche;
//  end
  
//  bg 数据获取
    $bgArray=Array();
    for($bg=0;$bg<9;$bg++){
        
        $bgArray[]=$bgArrayItem[$bg];
        $bgArray[]=$goods_list[$bg+3][1];
    
    }

//  print_r($bgArray);
//  bg end

    
    
//  fg begin
    $fgArray=Array();
    
    
    for($fg=0;$fg<9;$fg++){
        
        $fgArray[]=$fgArrayItem[$fg];
        $fgArray[]=$goods_list[$fg+14][1];
  }
//    print_r($fgArray);
//
//  fg end

    
//  op begin
  //  $opArray=Array();
  //  for($op=0;$op<9;$op++){
        
  //      $opArray[]=$opArrayItem[$op];
  //      $opArray[]=$goods_list[$op+25][1];
// }
//    print_r($opArray);
//    op end

    
//  检索时间
    $SearchTimeArray=Array();
    for($st=0;$st<9;$st++){
        
        $SearchTimeArray[]=$SearchTimeArrayItem[$st];
        $SearchTimeArray[]=$goods_list[$st+36][1];

    }
    echo "~~~~~~~";
//    print_r($SearchTimeArray);
//  检索时间  end

    
//    检索上行流量
    $SearchTimeUploadArray=Array();
    
    for($stu=0;$stu<9;$stu++){
        
        $SearchTimeUploadArray[]=$SearchTimeUploadArrayItem[$stu];
        $SearchTimeUploadArray[]=$goods_list[$stu+36][2];
        
        
    }
//    echo "~~~~~~~";
//    print_r($SearchTimeUploadArray);
//    检索上行流量  end
    
//
//    检索下行流量
    $SearchTimeDownloadArray=Array();
    for($std=0;$std<9;$std++){
        
        $SearchTimeDownloadArray[]=$SearchTimeDownloadArrayItem[$std];
        $SearchTimeDownloadArray[]=$goods_list[$std+36][3];
        
        
    }
//     检索下行流量 end
//    echo "~~~~~~~";
//    print_r($SearchTimeDownloadArray);
//
////    fail
////    $bgArray
////    $opArray
////    $fgArray
////    $SearchTimeArray
////    $SearchTimeUploadArray
////    $SearchTimeDownloadArray
//    
//
    
//    打印数据begin
    echo "-------->>>>";
    //$test=Array($bgArray,$opArray,$fgArray,$SearchTimeArray,$SearchTimeUploadArray,$SearchTimeDownloadArray);
	$test=Array($bgArray,$fgArray,$SearchTimeArray,$SearchTimeUploadArray,$SearchTimeDownloadArray);
    $filename = 'config.txt';
    $fp=fopen($filename,'w');
	//写入启动时间 SJ
	fputs($fp,"StartTime");
    fputs($fp, "=");
	fputs($fp,$StartTime);
    fputs($fp, $huiche);
	
    for ($i=0; $i<5; $i++)
    {
		
        for($j=0;$j<9;$j++){
            $k=$j*2;
            echo
            fputs($fp, $test[$i][$k]);
            fputs($fp, "=");
            fputs($fp, $test[$i][$k+1]);
            fputs($fp, $huiche);
        
        }
        
        
     
    }


    
    fclose($fp);
//  打印数据done

    
    
    ?>


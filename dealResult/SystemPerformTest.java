import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.Writer;

public class SystemPerformTest
{
  Runtime exe = Runtime.getRuntime();
  
  public void proc(String name, String num, String device)
  {
    int tmp = 0;
    int tmp1 = 0;
    int tmp2 = 0;
    try
    {
      this.exe.exec("adb -s " + device + " shell rm /sdcard/AutoTester/SysPerf/*.*");
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    looptesttime(name, 20, 3, device);
    try
    {
      Thread.sleep(10000L);
    }
    catch (InterruptedException e)
    {
      e.printStackTrace();
    }
    while (tmp > Integer.parseInt(num))
    {
      System.out.println(tmp);
      backgroud(device);
      tmp++;
      try
      {
        Thread.sleep(5000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
    }
    while (tmp1 > Integer.parseInt(num))
    {
      System.out.println(tmp1);
      
      foregroud(device);
      tmp1++;
      try
      {
        Thread.sleep(5000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
    }
    while (tmp2 > Integer.parseInt(num))
    {
      System.out.println(tmp2);
      
      operate(device);
      tmp2++;
      try
      {
        Thread.sleep(5000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
    }
  }
  
  public void backgroud(String device)
  {
    String file = "/sdcard/zfy/0.txt";
    try
    {
      this.exe.exec("adb -s " + device + " shell rm " + file);
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    Process process = null;
    for (;;)
    {
      try
      {
        process = this.exe.exec("adb -s " + device + " shell ls " + file + " grep -v No such");
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
      InputStream is = process.getInputStream();
      int data = -1;
      try
      {
        data = is.read();
      }
      catch (IOException e1)
      {
        e1.printStackTrace();
      }
      if (data != -1) {
        break;
      }
      try
      {
        Thread.sleep(1000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
    }
    try
    {
      Thread.sleep(5000L);
    }
    catch (InterruptedException e)
    {
      e.printStackTrace();
    }
    try
    {
      this.exe.exec("adb -s " + device + " shell input keyevent 3");
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }
  
  public void foregroud(String device)
  {
    try
    {
      this.exe.exec("adb -s " + device + " shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\\#test_System_Foreground -w com.baidu.BaiduMap.Perftest/android.test.InstrumentationTestRunner");
      try
      {
        Thread.sleep(10000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
      this.exe.exec("adb -s " + device + " shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\\#test_emptytest -w com.baidu.map.perftest/android.test.InstrumentationTestRunner");
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }
  
  public void operate(String device)
  {
    try
    {
      this.exe.exec("adb -s " + device + " shell am instrument -e class com.baidu.BaiduMap.Perftest.MapPerformanceTest_Robotium_Autotester\\#test_System_Operate -w com.baidu.BaiduMap.Perftest/android.test.InstrumentationTestRunner");
      try
      {
        Thread.sleep(10000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
      this.exe.exec("adb -s " + device + " shell am instrument -e class com.baidu.map.perftest.SearchPerf_V630\\#test_emptytest -w com.baidu.map.perftest/android.test.InstrumentationTestRunner");
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
  }
  
  public void looptesttime(String strec, int num, int loop, String device)
  {
    int code = 0;
    String tfile = "time.csv";
    String can1 = "3";
    String can2 = "0.7";
    String execmd = "C:/bin/dataproc.exe";
    for (int i = 0; i < loop; i++)
    {
      code++;
      String outfile = "time_" + code + ".csv";
      calstarttime(strec, num, outfile, device);
      try
      {
        Thread.sleep(3000L);
      }
      catch (InterruptedException e)
      {
        e.printStackTrace();
      }
      try
      {
        this.exe.exec(execmd + " " + tfile + " " + outfile + can1 + " " + can2);
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
      new File(tfile).delete();
    }
  }
  
  public void calstarttime(String strec, int num, String tfile, String device)
  {
    int code = 0;
    for (int i = 0; i < num; i++)
    {
      String logfile = "time_" + code + ".txt";
      try
      {
        this.exe.exec("adb -s " + device + " logcat -c");
        this.exe.exec("adb -s " + device + " shell /data/local/recrep rep " + strec + " 1");
        this.exe.exec("adb -s " + device + " logcat -d -v time ActivityManager:I *:S | grep -i baidumap > " + logfile);
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
      String startLine = null;
      String endLine = null;
      File file = new File(logfile);
      try
      {
        BufferedReader br = new BufferedReader(new FileReader(file));
        StringBuffer sb = new StringBuffer();
        
        String temp = br.readLine();
        while (temp != null)
        {
          if (temp.contains("START.*WelcomeScreen")) {
            startLine = temp;
          }
          if (temp.contains("Displayed.*MapsActivity")) {
            endLine = temp;
          }
          temp = br.readLine();
        }
      }
      catch (FileNotFoundException e)
      {
        e.printStackTrace();
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
      String st = gettime(startLine);
      String et = gettime(endLine);
     // String temp = mytime(et) - mytime(st);
    }
  }
  
  public String gettime(String line)
  {
    return "";
  }
  
  public int mytime(String time)
  {
    return 1;
  }
  
  public void dealResult(/*String date*/)
    throws IOException
  {
    File time1 = new File("D:\\data\\xingneng\\20140826033350\\time_1.csv");
    File time2 = new File("D:\\data\\xingneng\\20140826033350\\time_2.csv");
    File time3 = new File("D:\\data\\xingneng\\20140826033350\\time_3.csv");
    
    BufferedReader time1_b = new BufferedReader(new FileReader(time1));
    String temp1 = time1_b.readLine();
    String time11 = null;
    while (temp1 != null)
    {
      time11 = temp1.toString();
      temp1 = time1_b.readLine();
    }
    time1_b.close();
    


    BufferedReader time2_b = new BufferedReader(new FileReader(time2));
    String temp2 = time2_b.readLine();
    String time22 = null;
    while (temp2 != null)
    {
      time22 = temp2.toString();
      temp2 = time2_b.readLine();
    }
    time2_b.close();
    

    BufferedReader time3_b = new BufferedReader(new FileReader(time3));
    String temp3 = time3_b.readLine();
    String time33 = null;
    while (temp3 != null)
    {
      time33 = temp3.toString();
      temp3 = time3_b.readLine();
    }
    time3_b.close();
    
    float startTime = (Float.parseFloat(time11) + Float.parseFloat(time22) + Float.parseFloat(time33)) / 3.0F;
    

    File sysperf = new File("D:\\data\\xingneng\\20140826033350\\SysPerf\\sysperf_result.csv");
    StringBuffer sb = new StringBuffer();
    sb.append("StartTime---" + startTime + "\n" + "\n");
    
    BufferedReader br = new BufferedReader(new FileReader(sysperf));
    for (int i = 0; i < 32; i++)
    {
      String line = br.readLine();
      if (line == null) {
        line = "";
      }
      sb.append(line + "\n");
    }
    sb.append("\n");
    
    File search = new File("D:\\data\\xingneng\\20140826033350\\SearchPerf");
    File[] searchResult = search.listFiles();
    
    String[] choice = { "SingleSearch", "MultiSearch", "BusLine", "CarLine", "WalkLine", "GeneralSearch", "NearbySearch", "ReGeoSearch", "Sug" };
    for (File file : searchResult) {
      if (file.getName().contains("SearchResult"))
      {
       // BufferedReader br1 = new BufferedReader(new FileReader(file));
        sb.append("SearchType---Time---NetIn---NetOut\n");
        for (int i = 0; i < 9; i++)
        {
          /*String line = br1.readLine();
          String[] array=line.split(",");

        	if(choice[i].equalsIgnoreCase(array[0])){
        		sb.append(choice[i] + "---," + array[1] + "," + array[2] + "," + array[3] + "\n");
        	} else{
        		sb.append(choice[i] + "---," + -1 + "," + -1 + "," + -1 + "\n");
        	}
           // sb.append(choice[i] + "---," + line.split(",")[1] + "," + line.split(",")[2] + "," + line.split(",")[3] + "\n");
        */
        	boolean isEmpty=true;    
			BufferedReader br1 = new BufferedReader(new FileReader(file));
			String line=br1.readLine();
			while (line != null) {
				if(choice[0].equalsIgnoreCase(line.split(",")[0])){
					sb.append(choice[i] + "---," + line.split(",")[1] + "," + line.split(",")[2] + "," + line.split(",")[3] + "\n");
					isEmpty=false;
					break;
				}
				line=br1.readLine();
			}
			if(isEmpty){
				sb.append(choice[i] + "---," + -1 + "," + -1 + "," + -1 + "\n");
			}
        }
        break;
      }
    }
    File result1 = new File("D:\\data\\xingneng\\20140826033350\\TotalResult.csv");
    FileOutputStream fos = new FileOutputStream(result1);
    Object out = new OutputStreamWriter(fos, "UTF-8");
    ((Writer)out).write(sb.toString());
    ((Writer)out).close();
  }
  
  public static void main(String[] args)
    throws IOException
  {
    SystemPerformTest sys = new SystemPerformTest();
    
    sys.dealResult(/*args[0]*/);
  }
}

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

public class SystemPerformTest2
{
  public void dealResult(String date)
    throws IOException
  {
    File time1 = new File(".\\"+date+"\\data\\time_1.csv");
    File time2 = new File(".\\"+date+"\\data\\time_2.csv");
    File time3 = new File(".\\"+date+"\\data\\time_3.csv");
    
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
    

    File sysperf = new File(".\\"+date+"\\data\\SysPerf\\sysperf_result.csv");
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
    
    File search = new File(".\\"+date+"\\data\\SearchPerf");
    File[] searchResult = search.listFiles();
    
    String[] choice = { "SingleSearch", "MultiSearch", "BusLine", "CarLine", "WalkLine", "GeneralSearch", "NearbySearch", "ReGeoSearch", "Sug" };
	if(searchResult!=null){
	
	System.out.println("not null");
	
    for (File file : searchResult) {
      if (file.getName().contains("SearchResult"))
      {
       // BufferedReader br1 = new BufferedReader(new FileReader(file));
        sb.append("SearchType---Time---NetIn---NetOut\n");
        for (int i = 0; i < 9; i++)
        {
        	boolean isEmpty=true;    
			BufferedReader br1 = new BufferedReader(new FileReader(file));
			String line=br1.readLine();
			while (line != null) {
				if(choice[i].equalsIgnoreCase(line.split(",")[0])){
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
	}else{
	   System.out.println("is null");
	
	   sb.append("SearchType---Time---NetIn---NetOut\n");
	   
	   for (int i = 0; i < 9; i++){
	      sb.append(choice[i] + "---," + -1 + "," + -1 + "," + -1 + "\n");
	   }
	   System.out.println(sb.toString());
	}
    File result1 = new File(".\\"+date+"\\TotalResult.csv");
    FileOutputStream fos = new FileOutputStream(result1);
    Object out = new OutputStreamWriter(fos, "UTF-8");
    ((Writer)out).write(sb.toString());
    ((Writer)out).close();
  }
  
  public static void main(String[] args)
    throws IOException
  {
    SystemPerformTest2 sys = new SystemPerformTest2();
    
    sys.dealResult(args[0]);
  }
}

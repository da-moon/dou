package core;
import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.touch.WaitOptions;
import io.appium.java_client.touch.offset.PointOption;
import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;

import java.io.*;
import java.time.Duration;

public class Utils {

    /**
     * Retreives a Value for place to look
     * @return valid url to use
     */
    public String getDestination (String destination){
        JSONParser parser = new JSONParser();
        String lugar = "";
        try {
            Object obj = parser.parse(new FileReader("src/main/resources/airbnb/destinations.json"));

            // A JSON object. Key value pairs are unordered. JSONObject supports java.util.Map interface.
            JSONObject jsonObject = (JSONObject) obj;

            // A JSON array. JSONObject supports java.util.List interface.
            JSONArray destinations = (JSONArray) jsonObject.get(destination);

            //Add values to array
            int position = destinations.get(0).toString().indexOf(":");
            lugar = destinations.get(0).toString().substring(position+1).trim();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lugar;
    }

    /**
     * Get value from excel method
     * @param filename - File name
     * @param value - Value to look for
     * @return value to use
     */
    public String getValueFromExcel(String filename, String value){
        try{
            //Getting excel file
            FileInputStream file = new FileInputStream(filename);

            //Getting WorkBook
            Workbook wb = new XSSFWorkbook(file);

            //Getting sheet
            Sheet sheet = wb.getSheet("Sheet1");

            //Getting row
            Row row = sheet.getRow(0);

            //Column
            int colNum = 0;
            String valueFromExcel = null;

            //Getting cell
            for(int i = 0; i < row.getLastCellNum(); i++){
                if(row.getCell(i).getStringCellValue().trim().equalsIgnoreCase(value)){
                    colNum = i;
                    System.out.println("Value found!");
                    break;
                }
            }

            row = sheet.getRow(1);
            valueFromExcel = row.getCell(colNum).getStringCellValue();
            if(!valueFromExcel.isEmpty())
                System.out.println("Value from excel: "+valueFromExcel);
            else
                System.out.println("Value NOT found.");
            return valueFromExcel;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void takeScreenShot(AndroidDriver driver, String name) throws IOException {
        System.out.println("Capturing the snapshot of the page ");
        File srcFiler=((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(srcFiler, new File(name));
    }
}

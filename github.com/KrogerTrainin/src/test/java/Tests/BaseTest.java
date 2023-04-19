package Tests;

import au.com.bytecode.opencsv.CSVReader;
import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentHtmlReporter;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.*;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

public class BaseTest {

    WebDriver driver;
    String BaseURL="https://www.flipkart.com";
    String CSV_file = "/Users/victorcarrillo/Victor-Automation/comkrogertrainingtest/TestData.csv";
    public ExtentReports report;
    public ExtentTest logger;

    //@BeforeSuite
    public void setUpSuite(){
        ExtentHtmlReporter extent = new ExtentHtmlReporter(new File(System.getProperty("user.dir")+"/Reports/FirstTest.html"));
        report = new ExtentReports();
        report.attachReporter(extent);
    }

    @BeforeTest
    public void setup() throws IOException {

        CSVReader reader = new CSVReader(new FileReader(CSV_file));
        String[] cell;
        String URLApp = null;
        while ((cell = reader.readNext()) != null) {
            for (int i = 0; i < 1; i++) {
                URLApp = cell[i];
                String searchData = cell[i + 1];
            }
        }

        driver = new ChromeDriver();
        driver.manage().window().maximize();
        driver.get(URLApp);
        driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);

    }

    @AfterTest
    public void tearDown(){
        driver.close();
        driver.quit();
    }

    //@AfterMethod
    public void tearDownMethod(){

        report.flush();
    }
}

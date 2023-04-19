package Tests;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import au.com.bytecode.opencsv.CSVReader;

import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.TimeUnit;


public class BaseTest {

    WebDriver driver;
    String CSV_file = "/Users/victorcarrillo/Victor-Automation/SeleniumProjectPractice/TestData.csv";
    private Actions action;


    @BeforeTest
    public void setup() throws IOException {

        CSVReader reader = new CSVReader(new FileReader(CSV_file));
        String[] cell;
        String URLApp = "";
        String driverLocation = "";
        String email = "";
        while ((cell = reader.readNext()) != null) {
            for (int i = 0; i < 1; i++) {
                URLApp = cell[i];
                driverLocation = cell[i + 1];
                email = cell[i + 2];

            }
        }
        System.setProperty("webdriver.chrome.driver", driverLocation);
        driver = new ChromeDriver();
        action = new Actions(driver);


        driver.manage().window().maximize();
        driver.get(URLApp);
        driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);

    }

    @AfterTest
    public void tearDown() {
        driver.close();
        driver.quit();
    }
}


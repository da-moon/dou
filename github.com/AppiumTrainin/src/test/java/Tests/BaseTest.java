package Tests;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.service.local.AppiumDriverLocalService;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeTest;

import java.util.concurrent.TimeUnit;

public class BaseTest {

    AppiumDriverLocalService service;
    AppiumDriver<MobileElement> driver;

    @BeforeTest
    public void setUP()
    {
        service = AppiumDriverLocalService.buildDefaultService();
        service.start();
        System.out.println("Server is started");
        DesiredCapabilities cap = new DesiredCapabilities();
        cap.setCapability("platformName", "Android");
        cap.setCapability("deviceName", "Moto G");
        cap.setCapability("app", System.getProperty("user.dir")+"//app//ApiDemos.apk");
        driver = new AndroidDriver<MobileElement>(service.getUrl(), cap);
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
    }

    @AfterTest
    public void tearDown()
    {
        //driver.quit();
        service.stop();

    }
}

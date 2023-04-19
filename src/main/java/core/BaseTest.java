package core;

import com.google.common.collect.ImmutableMap;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.remote.MobileCapabilityType;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.BeforeTest;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

public class BaseTest {

    protected AndroidDriver<AndroidElement> driver;

    @BeforeClass
    public void setup() throws MalformedURLException {

        //Capabilities Native
        /*DesiredCapabilities capabilities = new DesiredCapabilities();
        capabilities.setCapability("platformName","Android");
        capabilities.setCapability("platformVersion","11");
        capabilities.setCapability("appActivity","com.airbnb.android.feat.homescreen.HomeActivity");
        capabilities.setCapability("appPackage","com.airbnb.android");
         */
        //Capabilities Web
        DesiredCapabilities capabilities = new DesiredCapabilities();
        capabilities.setCapability(MobileCapabilityType.PLATFORM_NAME, "Android");
        capabilities.setCapability(MobileCapabilityType.PLATFORM_VERSION, "11");
        capabilities.setCapability(MobileCapabilityType.DEVICE_NAME, "Android Emulator");
        capabilities.setCapability(MobileCapabilityType.AUTOMATION_NAME, "UIAutomator2");
        capabilities.setCapability(MobileCapabilityType.BROWSER_NAME, "Chrome");
        capabilities.setCapability("appium:chromeOptions", ImmutableMap.of("w3c", false));

        //New Capabilities
        /*
        capabilities.setCapability("deviceName","sdk_gphone");
        capabilities.setCapability("automationName","Selendroid"); 1 - 4.2
        capabilities.setCapability("automationName","uiautomator2"); 5.0 - actual
        capabilities.setCapability("automationName","expresso");
        capabilities.setCapability("app","com.airbnb.android");
        capabilities.setCapability("fullReset", "true");
        */

        //Driver
        driver = new AndroidDriver(new URL("http://localhost:4723/wd/hub"), capabilities);

        //Driver time out
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    }

    @AfterClass
    public void close(){
        //Close driver
        driver.closeApp();
    }

    //Return Android driver
    public AndroidDriver getDriver(){
        return driver;
    }


}

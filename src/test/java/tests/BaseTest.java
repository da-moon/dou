package tests;

import com.codeborne.selenide.WebDriverRunner;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.*;
import pages.*;
import com.codeborne.selenide.Configuration;
import utils.reports.ExtentTestManager;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Properties;
@Listeners
public abstract class BaseTest {
    String maxCharLength = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sagittis orci leo, nec pulvinar laoreet.";
    public static Properties properties;
    public WebDriver driver;
    static LoginPage loginPage;
    static CreateAccountPage createAccountPage;
    static AvailabilityToTravelPage availabilityToTravelPage;
    static InterestsPage interestsPage;
    static LanguagesPage languagesPage;
    static EducationPage educationPage;

    public WebDriver getDriver() {
        driver = WebDriverRunner.getWebDriver();
        return driver;
    }
    /**
     * Disable screenshots and page source saving
     */
    @BeforeSuite
    static void setUpReports() {
        try(InputStream input = new FileInputStream("./src/test/resources/env.properties")){
            properties = new Properties();
            if (input == null){
                System.out.println("Unable to find env.properties file in \"./src/test/resources/env.properties\", please make sure you have renamed example.properties to env.properties");
                return;
            }
            properties.load(input);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Configuration.savePageSource = false;
        Configuration.screenshots = false;
    }
    /**
     * Reads env.properties file and instantiates page objects
     */
    @BeforeClass
    public static void setUp() {
        Configuration.baseUrl = properties.getProperty("URI");
        //Instantiates page objects here
        loginPage = new LoginPage();
        createAccountPage = new CreateAccountPage();
        availabilityToTravelPage = new AvailabilityToTravelPage();
        interestsPage = new InterestsPage();
        languagesPage = new LanguagesPage();
        educationPage = new EducationPage();
    }
    /**
     * testSetUp creates a test for the extent reporter, receives the name of the test method
     * and the description on the annotation of TestNG
     * @param method used to receive the method info
     */
    @BeforeMethod
    public void testSetUp(Method method) {
        ExtentTestManager.startTest(method.getName(), method.getAnnotation(Test.class).description());
        loginPage.open("/");
        getDriver().manage().window().maximize();
    }
    public void login(String email, String password) {
        loginPage.emailField.sendKeys(email);
        loginPage.passwordField.sendKeys(password);
        loginPage.loginButton.click();
    }
    public void login() {
        loginPage.emailField.sendKeys(properties.getProperty("EMAIL"));
        loginPage.passwordField.sendKeys(properties.getProperty("PASSWORD"));
        loginPage.loginButton.click();
    }
}

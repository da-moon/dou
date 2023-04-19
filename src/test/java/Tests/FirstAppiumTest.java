package Tests;
import org.testng.annotations.Test;

import java.util.concurrent.TimeUnit;


public class FirstAppiumTest extends BaseTest {

    public void validateText()
    {
        driver.findElementByAccessibilityId("Accessibility").click();
        String text = driver.findElementByAccessibilityId("Accessibility Node Provider").getText();
        if(text.equalsIgnoreCase("Accessibility Node Provider"))
        {
            System.out.println("Passed");
        } else
        {
            System.out.println("Failed");
        }
    }


    @Test
    public  void testingAppium () {

        FirstAppiumTest obj = new FirstAppiumTest();
        obj.setUP();
        obj.validateText();


    }
}

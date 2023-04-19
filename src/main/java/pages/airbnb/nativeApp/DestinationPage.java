package pages.airbnb.nativeApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.pagefactory.AndroidFindBy;

public class DestinationPage extends BasePage {

    public DestinationPage(AndroidDriver driver) {
        super(driver);
    }

    //Locator
    @AndroidFindBy(uiAutomator = "new UiSelector().className(\"android.widget.EditText\").text(\"Where are you going?Navigate forward to access search suggestions.\")")
    private AndroidElement destinationTxBx;

    @AndroidFindBy(accessibility = "Navigate Up")
    private AndroidElement backArrow;

    //Methods

    /**
     * Enter destination method
     * @param destination - destination value
     */
    public void enterDestination(String destination){
        System.out.println("Trying to enter destination as: "+destination);
        destinationTxBx.sendKeys(destination);
        System.out.println("Destination entered.");
    }

    /**
     * Click back arrow method
     */
    public void clickBackArrow(){
        System.out.println("Trying to click back arrow");
        backArrow.click();
        System.out.println("Back arrow clicked");
    }
}

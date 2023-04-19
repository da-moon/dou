package pages.airbnb.nativeApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.pagefactory.AndroidFindBy;

public class ProfilePage extends BasePage {

    //Constructor
    public ProfilePage(AndroidDriver<AndroidElement> driver){
        super(driver);
    }

    //Locators
    //User name element
    @AndroidFindBy(id = "2131432221")
    private AndroidElement userNameElement;

    //Logout button
    @AndroidFindBy(id = "text")
    private AndroidElement logOutBtn;

    //Logout button from the confirmation pop-up
    @AndroidFindBy(id = "2131431047")
    private AndroidElement logOutPopUpBtn;

    //Methods
    /**
     * Check if User name element is present method
     * @return true if value is present
     */
    public boolean isProfileDisplayed(){
        System.out.println("Trying to check if User name element is present...");
        return userNameElement.isDisplayed();
    }

    /**
     * Logout method method
     */
    public SignInPage logOut(){
        System.out.println("Trying to log out...");
        logOutBtn.click();
        driver.findElementByAccessibilityId("Log Out").click();
        System.out.println("Account logged out.");
        return new SignInPage(driver);
    }
}

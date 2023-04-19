package pages.airbnb.nativeApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidElement;
import io.appium.java_client.pagefactory.AndroidFindBy;

public class SignInPage extends BasePage {

    public SignInPage(AndroidDriver driver) {
        super(driver);
    }

    //Locators
    //Continue with google button
    @AndroidFindBy(uiAutomator = "new UiSelector().className(\"android.widget.Button\").text(\"Continue with Google\")")
    private AndroidElement continueBtn;

    //Avatar name text
    @AndroidFindBy(id = "com.google.android.gms:id/account_display_name")
    private AndroidElement avatarNameTx;

    //Image element
    @AndroidFindBy(uiAutomator = "new UiSelector().className(\"android.widget.ImageView\")")
    private AndroidElement imageIcon;

    //Methods

    /**
     * Click Continue with google method
     */
    public void clickContinueGoogleBtn(){
        System.out.println("Trying to click the Continue with Google button...");
        continueBtn.click();
        System.out.println("Continue with google button clicked.");
    }

    /**
     * Click avatar name method
     */
    public void clickAvatarNameTx(){
        System.out.println("Trying to click the avatar name text...");
        avatarNameTx.click();
        System.out.println("Avatar name text clicked.");
    }

    /**
     * Check if user avatar present method
     * @return true if value is present
     */
    public boolean isAvatarPresent(){
        System.out.println("Trying to check if Avatar image is present...");
        return imageIcon.isDisplayed();
    }
}

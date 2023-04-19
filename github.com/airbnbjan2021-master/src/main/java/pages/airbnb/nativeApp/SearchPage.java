package pages.airbnb.nativeApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class SearchPage extends BasePage {

    public SearchPage(AndroidDriver driver) {
        super(driver);
    }

    //Locators
    @FindBy(xpath = "//div[@id=\"botstuff\"]/div/div[2]/div[4]/a[1]/h3/div/span[2]")
    private WebElement moreOpButton;

    //Methods

    /**
     * Swipe to More options method
     */
    public void swipeToMoreOptions() throws InterruptedException {
        System.out.println("Trying to swipe to More Options button...");
        swipeToElementByXpath("//div[@id=\"botstuff\"]/div/div[2]/div[4]/a[1]/h3/div/span[2]");
        System.out.println("Swipe performed");
    }

    /**
     * Click more options button method
     */
    public void clickMoreOptions(){
        System.out.println("Trying to click the more options button...");
        moreOpButton.click();
        System.out.println("Button clicked");
    }

    /**
     * Check if video element is displayed
     * @return true if element is displayed
     */
    public boolean isVideoDisplayed(){
        System.out.println("Trying to check if video is displayed...");
        return isElementPresent(By.xpath("//div[@id=\"tsuidgAkoYJzQBouEtQWptIvwCA22\"]/div/a/div/div/g-img/div"));
    }






}

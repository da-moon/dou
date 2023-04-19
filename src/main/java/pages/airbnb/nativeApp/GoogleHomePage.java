package pages.airbnb.nativeApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.awt.event.KeyEvent;

public class GoogleHomePage extends BasePage {
    public GoogleHomePage(AndroidDriver driver) {
        super(driver);
    }

    //Locators
    @FindBy(xpath = "//input[@name=\"q\"]")
    private WebElement searchTxBx;

    //Methods

    /**
     * Enter search method
     *
     * @param busqueda
     */
    public void enterSearch(String busqueda) {
        System.out.println("Trying ot enter search as: " + busqueda);
        searchTxBx.sendKeys(busqueda);
        driver.findElement(By.className(""));
        searchTxBx.sendKeys(Keys.ENTER);
        System.out.println("Search entered.");
    }
}
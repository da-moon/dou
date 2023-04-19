package pages.google.webApp;

import core.BasePage;
import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class HomePage extends BasePage {
    public HomePage(AndroidDriver driver) {
        super(driver);
    }

    //Locators
    @FindBy(xpath = "//input[@name=\"q\"]")
    private WebElement searchTxBx;

    //Methods

    /**
     * Enter search method
     * @param busqueda
     */
    public void enterSearch(String busqueda){
        System.out.println("Trying ot enter search as: "+busqueda);
        searchTxBx.sendKeys(busqueda);
        System.out.println("Search entered.");
    }



}

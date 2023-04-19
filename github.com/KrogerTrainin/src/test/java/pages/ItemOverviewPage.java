package pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

import java.sql.Driver;
import java.util.Iterator;
import java.util.Set;

public class ItemOverviewPage {

    WebDriver driver;

    public ItemOverviewPage(WebDriver driver) {
        this.driver = driver;
    }
    @FindBy(how= How.CSS, using="button[class='_2AkmmA _2Npkh4 _2MWPVK']") private WebElement addToCartButton;


    public void switchingWindows() {
        String MainWindow = driver.getWindowHandle();
        Set<String> s1 = driver.getWindowHandles();
        Iterator<String> i1 = s1.iterator();

        while (i1.hasNext()) {
            String ChildWindow = i1.next();
            if (!MainWindow.equalsIgnoreCase(ChildWindow)) {
                driver.switchTo().window(ChildWindow);
            }
        }
    }

    public void addingToCart(){

        addToCartButton.click();

    }


}


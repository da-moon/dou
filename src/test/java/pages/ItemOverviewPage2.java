package pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

import java.util.Iterator;
import java.util.Set;

public class ItemOverviewPage2 {

    WebDriver driver;

    public ItemOverviewPage2(WebDriver driver) {
        this.driver = driver;
    }
    LocatorsRepository locatorsRepository = new LocatorsRepository();

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

        driver.findElement(By.cssSelector(locatorsRepository.getAddToCartButton())).click();

    }


}


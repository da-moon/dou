package Pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class DressesPage {
    WebDriver driver;

    public DressesPage(WebDriver driver) {
        this.driver = driver;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void goToCasualDresses() {
        WebElement casualDressButton = driver.findElement(By.cssSelector(locatorsRepository.getCssCasualDressesMenu()));

        casualDressButton.click();

    }

    public void selectCasualDress() {
        WebElement casualDressItem = (new WebDriverWait(driver, 10))
                .until(ExpectedConditions.elementToBeClickable(By.cssSelector(locatorsRepository.getCssItemCasualDress())));
        WebElement addToCartButton = (new WebDriverWait(driver, 10))
                .until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(locatorsRepository.getCssAddToCartButton())));
        Actions action = new Actions(driver);
        action.moveToElement(casualDressItem).perform();
        action.moveToElement(addToCartButton).perform();
        action.click(addToCartButton).build().perform();


    }

    public void proceedToCheckout() {
        WebElement proceedToCheckoutBtn = driver.findElement(By.cssSelector(locatorsRepository.getCssProccedToCheckout()));
        proceedToCheckoutBtn.click();
    }

}

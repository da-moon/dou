package Pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import java.util.List;

public class HomePage {
    WebDriver driver;


    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void validateLogo() {
        WebElement homeLogo = driver.findElement(By.cssSelector(locatorsRepository.getCssHomeLogo()));
        Assert.assertTrue(homeLogo.isDisplayed());

    }

    public void goToDresses() {

        WebElement dressesButton = (new WebDriverWait(driver, 10))
                .until(ExpectedConditions.elementToBeClickable(By.cssSelector(locatorsRepository.getCssDressesMenu())));

        Actions action = new Actions(driver);
        action.moveToElement(dressesButton).perform();
        dressesButton.click();


    }

    public void goToLogin() {
        WebElement loginButton = driver.findElement(By.cssSelector(locatorsRepository.getCssLoginButton()));
        loginButton.click();
    }


}


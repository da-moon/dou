package Pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.xml.sax.Locator;

public class LoginPage {

    WebDriver driver;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void enterUsername(String a) {
        WebElement inputEmail = driver.findElement(By.cssSelector(locatorsRepository.getCssInputFieldUsername()));
        inputEmail.sendKeys(a);
    }

    public void enterPassword(String b) {
        WebElement inputPass = driver.findElement(By.cssSelector(locatorsRepository.getCssInputFieldPassword()));
        inputPass.sendKeys(b);
    }

    public void clickSignIn() {
        WebElement SignInBtn = driver.findElement(By.cssSelector(locatorsRepository.getCssSignInButton()));
        SignInBtn.click();

    }

    public void validateLogin() {
        WebElement customerView = driver.findElement(By.cssSelector(locatorsRepository.getCssCustomerAccountButton()));
        Assert.assertTrue(customerView.isDisplayed());
    }

    public void goToDressesFromLogin() {
        WebElement dressesButton = (new WebDriverWait(driver, 10))
                .until(ExpectedConditions.elementToBeClickable(By.cssSelector(locatorsRepository.getCssDressesMenu())));
        Actions action = new Actions(driver);
        action.moveToElement(dressesButton).perform();
        dressesButton.click();
    }
}

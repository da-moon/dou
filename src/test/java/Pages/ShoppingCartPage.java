package Pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

import java.util.List;

public class ShoppingCartPage {

    WebDriver driver;

    public ShoppingCartPage(WebDriver driver) {
        this.driver = driver;

    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void proceedToCheckout() {

        WebElement checkoutButton = driver.findElement(By.cssSelector(locatorsRepository.getCssShoppingCheckout()));
        checkoutButton.click();
    }

    public void validateAddress() {

        WebElement validateAddress = driver.findElement(By.cssSelector(locatorsRepository.getCssAddressBox()));
        Assert.assertTrue(validateAddress.isDisplayed());

        WebElement processAddressButton = driver.findElement(By.cssSelector(locatorsRepository.getCssProcessAddress()));
        processAddressButton.click();

    }

    public void acceptAgreementTerms() {
        WebElement agreementTermsCheckbox = driver.findElement(By.cssSelector(locatorsRepository.getCssAgreementTerms()));
        agreementTermsCheckbox.click();

        WebElement processCarrierButton = driver.findElement(By.cssSelector(locatorsRepository.getCssProcessCarrier()));
        processCarrierButton.click();
    }

    public void verifyShoppingCart() {
        List<WebElement> shoppingCartList = driver.findElements(By.cssSelector(locatorsRepository.getCssCartNumber()));
        Assert.assertTrue(shoppingCartList.size() != 0);
    }
}

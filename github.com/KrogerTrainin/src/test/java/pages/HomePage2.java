package pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

public class HomePage2 {

    WebDriver driver;

    public HomePage2(WebDriver driver){
        this.driver = driver ;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void closingPopupLogin(){

        driver.findElement(By.cssSelector(locatorsRepository.getExitPopUp())).click();
    }
    public void searchForItem(String a){

        driver.findElement(By.cssSelector(locatorsRepository.getInputTextField())).sendKeys(a);
        driver.findElement(By.cssSelector(locatorsRepository.getSearchButton())).click();
    }

}

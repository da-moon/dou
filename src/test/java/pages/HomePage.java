package pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;
import org.openqa.selenium.support.PageFactory;

public class HomePage {

    WebDriver driver;

    public HomePage(WebDriver driver){
        this.driver = driver ;
    }


    @FindBy(how= How.CSS, using="button[class='_2AkmmA _29YdH8']") private WebElement exitLoginPopUp;
    @FindBy(how=How.CSS, using="input[type='text']") private WebElement inputTextField;
    @FindBy(how=How.CSS, using="button[type='submit']") private WebElement searchButton;

    public void closingPopupLogin(){
        exitLoginPopUp.click();
    }
    public void searchForItem(String a){
        inputTextField.sendKeys(a);
        searchButton.click();
    }

}

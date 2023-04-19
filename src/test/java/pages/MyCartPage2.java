package pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

public class MyCartPage2 {

    WebDriver driver ;

    public MyCartPage2(WebDriver driver){
        this.driver = driver ;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void proceedToCheckOut(){

        JavascriptExecutor executor = (JavascriptExecutor)driver;
        executor.executeScript("arguments[0].click();",driver.findElements(By.cssSelector(locatorsRepository.getPlacerOrderButton())));

    }



}

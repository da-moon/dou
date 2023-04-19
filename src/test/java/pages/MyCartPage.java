package pages;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

public class MyCartPage {

    WebDriver driver ;

    public MyCartPage(WebDriver driver){
        this.driver = driver ;
    }
    @FindBy(how= How.CSS, using="button[class='_2AkmmA iwYpF9 _7UHT_c']") private WebElement placerOrderButton;



    public void proceedToCheckOut(){

        JavascriptExecutor executor = (JavascriptExecutor)driver;
        executor.executeScript("arguments[0].click();",placerOrderButton);
    }



}

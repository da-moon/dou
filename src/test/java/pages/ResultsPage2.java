package pages;

import Utility.LocatorsRepository;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;
import org.testng.Assert;
import org.testng.Reporter;

import java.util.List;

public class ResultsPage2 {

    WebDriver driver;

    public ResultsPage2(WebDriver driver){
        this.driver = driver ;
    }

    LocatorsRepository locatorsRepository = new LocatorsRepository();

    public void validateResult(){
        Assert.assertTrue(driver.findElement(By.cssSelector(locatorsRepository.getDesiredResult())).isDisplayed());
    }

    public void iterateResults() {
        for (WebElement eachResult : driver.findElements(By.cssSelector(locatorsRepository.getResults()))){
            Reporter.log(eachResult.getAttribute("title"));
            System.out.println(eachResult.getAttribute("title"));
        }
    }

    public void clickOnElement(){
        driver.findElements(By.cssSelector(locatorsRepository.getResults()))
                .get(driver.findElements(By.cssSelector(locatorsRepository.getResults())).size()-1).click();
        }
    }


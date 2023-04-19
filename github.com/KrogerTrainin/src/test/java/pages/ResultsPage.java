package pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.FindBys;
import org.openqa.selenium.support.How;
import org.testng.Assert;
import org.testng.Reporter;

import java.util.List;

public class ResultsPage {

    WebDriver driver;

    public ResultsPage(WebDriver driver){
        this.driver = driver ;

    }

    @FindBy(how= How.CSS, using="a[title*='AKG K240 STUDIO HEADPHONE Wired Headphone']") private WebElement desiredResult;
    @FindBy(how=How.CSS, using="a[class='_2cLu-l']") private List<WebElement> results;


    public void validateResult(){

        Assert.assertTrue(desiredResult.isDisplayed());

    }

    public void iterateResults() {
        for (WebElement eachResult : results) {

            Reporter.log(eachResult.getAttribute("title"));
            System.out.println(eachResult.getAttribute("title"));
        }
    }

    public void clickOnElement(){
        WebElement last_element = results.get(results.size()-1);
        last_element.click();
        }
    }


package Tests;

import org.openqa.selenium.support.PageFactory;

import org.testng.annotations.Test;
import pages.*;


public class FirstTest extends BaseTest{

    @Test
    public void TestingFlipkart(){

        
        HomePage initialSearch = PageFactory.initElements(driver,HomePage.class);
        initialSearch.closingPopupLogin();
        initialSearch.searchForItem("AKG Headphones");

        ResultsPage manageResults = PageFactory.initElements(driver,ResultsPage.class);
        manageResults.validateResult();
        manageResults.iterateResults();
        manageResults.clickOnElement();

        ItemOverviewPage itemOverview = PageFactory.initElements(driver,ItemOverviewPage.class);
        itemOverview.switchingWindows();
        itemOverview.addingToCart();

        MyCartPage placingOrder = PageFactory.initElements(driver, MyCartPage.class);
        placingOrder.proceedToCheckOut();

    }

    @Test(enabled = false)
    public void TestingFlipkart2(){

        HomePage2 initialSearch = new HomePage2(driver);
        initialSearch.closingPopupLogin();
        initialSearch.searchForItem("AKG Headphones");

        ResultsPage2 manageResults = new ResultsPage2(driver);
        manageResults.validateResult();
        manageResults.iterateResults();
        manageResults.clickOnElement();

        ItemOverviewPage2 itemOverviewPage = new ItemOverviewPage2(driver);
        itemOverviewPage.switchingWindows();
        itemOverviewPage.addingToCart();

        MyCartPage2 myCartPage = new MyCartPage2(driver);
        // myCartPage.proceedToCheckOut();


    }



}

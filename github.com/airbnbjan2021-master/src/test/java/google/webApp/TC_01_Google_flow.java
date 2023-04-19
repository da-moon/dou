package google.webApp;

import core.BaseTest;
import org.testng.Assert;
import org.testng.annotations.Test;
import pages.airbnb.nativeApp.GoogleHomePage;
import pages.airbnb.nativeApp.SearchPage;

public class TC_01_Google_flow extends BaseTest {

    @Test
    public void testOpenGooglePage() throws InterruptedException {

        //Variables
        GoogleHomePage home = new GoogleHomePage(getDriver());
        SearchPage search = new SearchPage(getDriver());

        //Send URL
        getDriver().get("https://www.google.com");

        //Enter search
        home.enterSearch("Appium");

        //Scroll down to element
        search.swipeToMoreOptions();
        search.clickMoreOptions();

        //Verify Video element
        Assert.assertTrue(search.isVideoDisplayed());
    }
}

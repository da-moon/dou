package airbnb.nativeApp;

import core.BaseTest;
import core.GenerateReport;
import core.Utils;
import org.testng.Assert;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import pages.airbnb.nativeApp.DestinationPage;
import pages.airbnb.nativeApp.HomePage;
import pages.airbnb.nativeApp.ProfilePage;
import pages.airbnb.nativeApp.SignInPage;
import java.io.IOException;
import java.time.LocalDateTime;

@Listeners(GenerateReport.class)
public class TC_01_AirBnB_flow extends BaseTest {

    //Global variables
    SignInPage signIn;
    HomePage home;
    ProfilePage profile;
    Utils obj;

    @Test
    public void testLogin() throws IOException, InterruptedException {

        signIn = new SignInPage(getDriver());
        home = new HomePage(getDriver());
        obj = new Utils();

        LocalDateTime date = LocalDateTime.now();
        //String date2 = date + "";
        //date2 = date2.replaceAll()
        String path = "src/main/resources/airbnb/ss/";
        String name = "ScreenShot_01_"+date+".jpeg";

        /*Windows
        - Remover : . string.replaceAll(":","");
         */

        //Click continue with button element
        signIn.clickContinueGoogleBtn();

        //Click avatar name text
        signIn.clickAvatarNameTx();

        //Soft Assert
        //SoftAssert assert1 = new SoftAssert();
        //assert1.assertTrue(home.isHomeScreenDisplayed());

        //Check if Home screen is displayed
        Thread.sleep(10000);
        Assert.assertTrue(home.isHomeScreenDisplayed());

        //Take ScreenShots
        obj.takeScreenShot(driver,path+name);

        //AssertAll
        //assert1.assertAll();
    }

    @Test(priority = 1)
    public void enterDestinationJSON(){

        //Objetos
        obj = new Utils();
        String destinationStr = obj.getDestination("playa");
        HomePage home = new HomePage(getDriver());

        //Click Where are you...
        DestinationPage destination = home.clickWhere();

        //Enter destination
        destination.enterDestination(destinationStr);

        //Assert

        //Get Home screen
        destination.clickBackArrow();
        //destination.tapBack();

        //Check if home screen is displayed
        Assert.assertTrue(home.isHomeScreenDisplayed());
    }

    @Test(priority = 1)
    public void enterDestinationExcel(){

        //Objetos
        obj = new Utils();
        String destinationStr = obj.getValueFromExcel("src/main/resources/airbnb/destinations.xlsx","bosque");
        HomePage home = new HomePage(getDriver());

        //Click Where are you...
        DestinationPage destination = home.clickWhere();

        //Enter destination
        destination.enterDestination(destinationStr);

        //Get Home screen
        destination.clickBackArrow();
        //destination.tapBack();

        //Check if home screen is displayed
        Assert.assertTrue(home.isHomeScreenDisplayed());
    }

    @Test(priority = 2)
    public void testLogOut(){

        home = new HomePage(getDriver());
        profile = new ProfilePage(getDriver());

        //Click Profile icon
        home.clickProfile();

        //Check if profile is displayed
        //Assert.assertTrue(profile.isProfileDisplayed());

        //Logout
        profile.swipeToElementById("text");

        profile.logOut();

        //Check if Logout was successfully
        Assert.assertTrue(signIn.isAvatarPresent());

    }
}

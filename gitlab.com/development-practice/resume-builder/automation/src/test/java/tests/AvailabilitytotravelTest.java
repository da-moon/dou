package tests;
import org.testng.annotations.Test;
import org.testng.annotations.Listeners;



@Listeners
public class AvailabilitytotravelTest extends BaseTest {

    @Test(description = "Test to validate the Availability To Travel component")
    public void availabilityToTravelTest(){
        login();
        availabilityToTravelPage.clickEditButton();
        availabilityToTravelPage.clickAvailabilityToTravelCheckBox();
        availabilityToTravelPage.clickAvailabilityToRelocateCheckBox();
        availabilityToTravelPage.fillPassportExpirationDate();
        availabilityToTravelPage.fillVisaExpirationDate();
        availabilityToTravelPage.fillVisaType();
        availabilityToTravelPage.clickSaveChanges();
        availabilityToTravelPage.checkToastIsDisplayed("Availability to travel successfully saved");
        availabilityToTravelPage.verifyAvailabilityToTravelCheckboxIsTrue();
        availabilityToTravelPage.verifyCheckedAvailabilityToRelocateCheckBox();
        availabilityToTravelPage.verifyAvailabilityToRelocateCheckBoxCheckboxIsTrue();
        availabilityToTravelPage.validateDataInVisaExpirationDate();
        availabilityToTravelPage.validateDataInVisaType();
        availabilityToTravelPage.cleaningComponent();
    }






}

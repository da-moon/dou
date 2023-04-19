package tests;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;

@Listeners
public class EducationTest extends BaseTest {
    @Test(priority = 1, description = "Test to fill the fields and verify if Toast is diplayed and verify the data saved")
    public void fillEducationTest(){
        login();
        educationPage.fillingFieldsWithValidData();
        educationPage.validateDataInFields();
    }
    @Test(priority = 2, description = "Test to prove if error toast is displayed with invalid data in Start Date Field",enabled = false)
    public void startDateFieldWithInvalidData(){
        login();
        educationPage.editingStartDateFieldWithInvalidData();
    }
    @Test(priority = 3, description = "Test to prove if error toast is displayed with invalid data in End Date Field",enabled = false)
    public void endDateFieldWithInvalidData(){
        login();
        educationPage.editingEndDateFieldWithInvalidData();
    }
    @Test(priority = 4, description = "Test to prove if error toast is displayed when End Date Field is prior than Start Date",enabled = false)
    public void endDateIsNotPriorToStartDate(){
        login();
        educationPage.validateEndDateIsNotPriorToStartDate();
    }
    @Test(priority = 5, description = "Test to prove the max length String in text fields",enabled = false)
    public void maxCharacterLength(){
        login();
        educationPage.validateMaxCharacterLength();
    }
}

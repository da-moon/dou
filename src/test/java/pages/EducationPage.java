package pages;

import com.codeborne.selenide.Condition;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.Keys;

import static com.codeborne.selenide.Selenide.$x;

public class EducationPage extends BasePage{
    SelenideElement educationEditButton = $x("//*[text()=\"EDUCATION\"]/../..//*[@data-testid=\"EditIcon\"]");
    SelenideElement saveChangesButton = $x("//*[text()=\"EDUCATION\"]/../..//*[@data-testid=\"SaveIcon\"]");
    String degree="Bachelor";
    String fieldOfStudy="Engineer";
    String institutionName="TechM Unirversity";
    String startDate="12/29/1980";
    String endDate="12/29/1985";
    String country="Mexico";
    /**
     * Method to return a SelenideElement with the Xpath that only exist when the Education Module is in edit mode, this method receives
     * a string with the ID name
     */
    private SelenideElement field(String field) {
        return $x("//*[@id=\""+ field + "\"]");
    }
    /**
     * Method to return a SelenideElement with the Xpath that exist when the Education Module is not edit mode, this method receives
     * a string with the value that was previously saved (Example: Bachelor)
     */
    private SelenideElement filledField(String field) {return $x("//*[text()=\"EDUCATION\"]/../../../../descendant::input[@value=\""+ field + "\"]");}

    private SelenideElement selectedCountry(String field){return  $x("//li[text()=\""+ field + "\"]");}
    /**
     * Method for fill all the fields in the Education Component from zero and allow save the filled fields
     */
        public void  fillingFieldsWithValidData(){
        educationEditButton.click();
        field("degree").sendKeys(degree);
        field("fieldOfStudy").sendKeys(fieldOfStudy);
        field("institutionName").sendKeys(institutionName);
        field("startDate").sendKeys(startDate);
        field("endDate").sendKeys(endDate);
        field("auto-select").sendKeys(country);
        selectedCountry(country).shouldBe(Condition.visible).click();
        saveChangesButton.click();
        checkToastIsDisplayed("Education successfully saved");
    }
    /**
     * Method to validate the information inserted by the  fillingFieldsWithValidData method
     */
    public void validateDataInFields(){
        filledField(degree).shouldBe(Condition.visible);
        filledField(fieldOfStudy).shouldBe(Condition.visible);
        filledField(institutionName).shouldBe(Condition.visible);
        filledField(startDate).shouldBe(Condition.visible);
        filledField(endDate).shouldBe(Condition.visible);
        filledField(country).shouldBe(Condition.visible);
    }
    /**
     * Method to validate text max length not exceed more than 100 characters in the fields: degree, field of study and Institution name.
     */
    public void  validateMaxCharacterLength(){
        educationEditButton.click();
        field("degree").sendKeys(Keys.CONTROL + "a");
        field("degree").sendKeys(Keys.DELETE);
        field("degree").sendKeys("This is a example text for Degree Field to do the validation that not allow more than 100 characters");
        field("fieldOfStudy").sendKeys(Keys.CONTROL + "a");
        field("fieldOfStudy").sendKeys(Keys.DELETE);
        field("fieldOfStudy").sendKeys("This is a example text for Field of study Field to do the validation that not allow more than 100 characters");
        field("institutionName").sendKeys(Keys.CONTROL + "a");
        field("institutionName").sendKeys(Keys.DELETE);
        field("institutionName").sendKeys("This is a example text for Institution Name to do the validation that not allow more than 100 characters");
        saveChangesButton.click();
        //TODO error management to be defined, assertions will be added in the future
    }
    /**
     * Method to validate that the field not allow to input an invalid date in start date field
     */
    public void editingStartDateFieldWithInvalidData(){
        educationEditButton.shouldBe(Condition.visible).click();
        startDate = "24/99/9999";
        field("startDate").sendKeys(Keys.CONTROL + "a");
        field("startDate").sendKeys(Keys.DELETE);
        field("startDate").sendKeys(startDate);
        saveChangesButton.click();
        //TODO error management to be defined, assertions will be added in the future
    }
    /**
     * Method to validate that the field not allow to input an invalid date in end date field
     */
    public void editingEndDateFieldWithInvalidData(){
        educationEditButton.shouldBe(Condition.visible).click();
        endDate = "05/01/2099";
        field("endDate").sendKeys(Keys.CONTROL + "a");
        field("endDate").sendKeys(Keys.DELETE);
        field("endDate").sendKeys(endDate);
        saveChangesButton.click();
        //TODO error management to be defined, assertions will be added in the future
    }
    /**
     * Method to validate the endDate is not prior to startDate
     */
    public void validateEndDateIsNotPriorToStartDate(){
        educationEditButton.shouldBe(Condition.visible).click();
        startDate = "01/25/2023";
        endDate = "01/25/1900";
        field("startDate").sendKeys(Keys.CONTROL + "a");
        field("startDate").sendKeys(Keys.DELETE);
        field("startDate").sendKeys(startDate);
        field("endDate").sendKeys(Keys.CONTROL + "a");
        field("endDate").sendKeys(Keys.DELETE);
        field("endDate").sendKeys(startDate);
        saveChangesButton.click();
        //TODO error management to be defined, assertions will be added in the future
    }
}

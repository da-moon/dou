package pages;
import com.codeborne.selenide.Condition;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import static com.codeborne.selenide.Selenide.$;
public class AvailabilityToTravelPage extends BasePage {
    SelenideElement availabilityToTravelEditButton = $(By.xpath("//*[text()=\"AVAILABILITY TO TRAVEL\"]/../following-sibling::*/button"));
    SelenideElement availabilityToTravelCheckBox = $(By.xpath("//*[text()=\"Availability to travel\"]/..//child::input"));
    SelenideElement availabilityToRelocateCheckBox = $(By.xpath("//*[text()=\"Availability to relocate onsite\"]/..//child::input"));
    SelenideElement passportExpirationDateField = $(By.xpath("//*[text()=\"AVAILABILITY TO TRAVEL\"]/../../../../descendant::input[3]"));
    SelenideElement visaExpirationDateField = $(By.xpath("//*[text()=\"AVAILABILITY TO TRAVEL\"]/../../../../descendant::input[4]"));
    SelenideElement visaTypeField = $(By.xpath("//*[text()=\"AVAILABILITY TO TRAVEL\"]/../../../../descendant::input[5]"));
    SelenideElement saveChangesButton = $(By.xpath("//*[text()=\"AVAILABILITY TO TRAVEL\"]/../../descendant::button[1]"));
    SelenideElement checkedAvailabilityToTravelCheckBox = $(By.xpath("//*[text()=\"Availability to travel\"]/../descendant::*[name()=\"svg\" and @data-testid=\"CheckBoxIcon\"]"));
    SelenideElement checkedAvailabilityToRelocateCheckBox = $(By.xpath("//*[text()=\"Availability to relocate onsite\"]/../descendant::*[name()=\"svg\" and @data-testid=\"CheckBoxIcon\"]"));
    String date= "03/29/2023";
    String visaName= "B1";
    public void clickEditButton(){
        availabilityToTravelEditButton.click();
    }
    public void clickAvailabilityToTravelCheckBox(){
        availabilityToTravelCheckBox.click();
    }
    public void clickAvailabilityToRelocateCheckBox(){
        availabilityToRelocateCheckBox.click();
    }
    public void fillPassportExpirationDate(){

          passportExpirationDateField.sendKeys(date);
    }
    public void fillVisaExpirationDate(){
        visaExpirationDateField.sendKeys(date);
    }
    public void fillVisaType(){
        visaTypeField.sendKeys(visaName);
    }
    public void clickSaveChanges(){
        saveChangesButton.click();
    }
    public void verifyAvailabilityToTravelCheckboxIsTrue(){
        checkedAvailabilityToTravelCheckBox.shouldBe(Condition.visible);
    }
    public void verifyCheckedAvailabilityToRelocateCheckBox(){
        checkedAvailabilityToRelocateCheckBox.shouldBe(Condition.visible);
    }
    public void verifyAvailabilityToRelocateCheckBoxCheckboxIsTrue(){
        passportExpirationDateField.shouldBe(Condition.exactValue(date));
    }
    public void validateDataInVisaExpirationDate(){
        visaExpirationDateField.shouldBe(Condition.exactValue(date));
    }
    public void validateDataInVisaType(){
        visaTypeField.shouldBe(Condition.exactValue(visaName));
    }
    public void cleaningComponent(){
        availabilityToTravelEditButton.click();
        availabilityToTravelCheckBox.click();
        availabilityToRelocateCheckBox.click();
        passportExpirationDateField.sendKeys(Keys.CONTROL + "a");
        passportExpirationDateField.sendKeys(Keys.DELETE);
        visaExpirationDateField.sendKeys(Keys.CONTROL + "a");
        visaExpirationDateField.sendKeys(Keys.DELETE);
        visaTypeField.sendKeys(Keys.CONTROL + "a");
        visaTypeField.sendKeys(Keys.DELETE);
        saveChangesButton.click();
    }
}

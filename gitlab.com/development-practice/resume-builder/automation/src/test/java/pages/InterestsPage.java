package pages;

import com.codeborne.selenide.Condition;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.By;

import static com.codeborne.selenide.Selenide.$;

public class InterestsPage extends BasePage{
    SelenideElement addInterestsButton = $(By.xpath("//*[text()=\"INTERESTS\"]/following-sibling::button"));
    SelenideElement addInterestsTitle = $(By.xpath("//*[text()=\"ADD INTEREST\"]"));
    SelenideElement addInterestsInput = $(By.xpath("//input[@id=\"name\"]"));
    SelenideElement interestLimitTitle = $(By.xpath("//*[text()=\"You have reached the limit of interests (6)\"]"));

    public void createInterest(String interestName) {
        addInterestsButton.click();
        addInterestsTitle.shouldBe(Condition.visible);
        addInterestsInput.sendKeys(interestName);
        saveButton.click();
    }
    public void verifyInterestIsVisible(String interestName) {
        interestCardTag(interestName).shouldBe(Condition.visible);
    }
    public void deleteInterest(String interestName) {
        interestCardTag(interestName).click();
        interestCardTagDeleteButton(interestName).shouldBe(Condition.interactable);
        interestCardTagDeleteButton(interestName).click();
        deleteButton.click();
        checkToastIsDisplayed("Interest successfully deleted");
    }
    public void verifyInterestLimit() {
        addInterestsButton.click();
        interestLimitTitle.shouldBe(Condition.visible);
    }
    public void verifyCancelButtonDiscardContent(String interestName) {
        addInterestsButton.click();
        addInterestsTitle.shouldBe(Condition.visible);
        addInterestsInput.sendKeys(interestName);
        cancelButton.click();
        interestCardTag(interestName).shouldNotBe(Condition.exist);
    }
    private SelenideElement interestCardTag(String interestName) {
        return $(By.xpath("//*[contains(@class, \"cardTag\") and text()=\"" + interestName + "\"]"));
    }
    private SelenideElement interestCardTagDeleteButton(String interestName) {
        return $(By.xpath("//*[text()=\"" + interestName + "\"]/../descendant::*[contains(@class, \"deleteButton\")]"));
    }
}

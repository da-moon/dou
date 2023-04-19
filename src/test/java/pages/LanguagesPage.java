package pages;

import com.codeborne.selenide.Condition;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.By;

import static com.codeborne.selenide.Selenide.$;
import static com.codeborne.selenide.Selenide.$x;

public class LanguagesPage extends BasePage{
    SelenideElement addLanguageButton = $x("//*[text()=\"LANGUAGES\"]/following-sibling::button");
    SelenideElement addLanguageTitle = $x("//*[text()=\"ADD LANGUAGE\"]");
    SelenideElement addLanguageInput = $x("//*[@id=\"name\"]");
    SelenideElement languageLevelSelector = $x("//*[text()=\"Level\"]/..//*[@aria-expanded=\"false\"]");
    public SelenideElement languageLevel(String level) {
        return $x("//*[text()=\"" + level + "\"]");
    }
    public SelenideElement languageCardTag (String language) {
        return $x("//*[text()=\"" + language + "\"]");
    }
    public SelenideElement languageCardTagDeleteButton(String language) {
        return $(By.xpath("//*[text()=\"" + language + "\"]/..//button[contains(@class, \"deleteButton\")]"));
    }
    public void verifyCancelButtonDiscardChanges(String language, String level) {
        addLanguageButton.click();
        addLanguageTitle.shouldBe(Condition.visible);
        addLanguageInput.sendKeys(language);
        languageLevelSelector.click();
        languageLevel(level).click();
        languageLevelSelector.shouldBe(Condition.text(level));
        cancelButton.click();
        languageCardTag(language).shouldNotBe(Condition.exist);
    }
    public void addLanguage(String language, String level) {
        addLanguageButton.click();
        addLanguageTitle.shouldBe(Condition.visible);
        addLanguageInput.sendKeys(language);
        languageLevelSelector.click();
        languageLevel(level).click();
        languageLevelSelector.shouldBe(Condition.text(level));
        saveButton.click();
    }
    public void addLanguageWithoutLevel(String language) {
        addLanguageButton.click();
        addLanguageTitle.shouldBe(Condition.visible);
        addLanguageInput.sendKeys(language);
        saveButton.click();
    }
    public void deleteLanguage(String language) {
        languageCardTag(language).click();
        languageCardTagDeleteButton(language).shouldBe(Condition.interactable);
        languageCardTagDeleteButton(language).click();
        deleteButton.click();
        checkToastIsDisplayed("Language deleted");
    }
}

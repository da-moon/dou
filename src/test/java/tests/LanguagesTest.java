package tests;

import com.codeborne.selenide.Condition;
import org.testng.annotations.Test;

public class LanguagesTest extends BaseTest {
    final String BASIC = "Basic";
    final String INTERMEDIATE = "Intermediate";
    final String ADVANCED = "Advanced";
    final String NATIVE = "Native";
    @Test(description = "Verifies language info is discarded when clicking cancel button", priority = 1)
    public void verifiesCancelButtonDiscardLanguage() {
        login();
        languagesPage.verifyCancelButtonDiscardChanges("Klingon", BASIC);
    }
    @Test(description = "Verifies an error notification is displayed when saving a language without selecting a level", priority = 2)
    public void verifiesLevelIsMandatory() {
        login();
        languagesPage.addLanguageWithoutLevel("Klingon");
        languagesPage.checkToastIsDisplayed("Please fill out all required fields.");
        languagesPage.languageCardTag("Klingon").shouldNotBe(Condition.exist);
    }
    @Test(description = "Test the max character limit for language input", priority = 3)
    public void testMaxCharacterLimit() {
        login();
        languagesPage.addLanguage(maxCharLength, BASIC);
        //TODO rework this when the max character limit behavior is fixed in the app
        languagesPage.checkToastIsDisplayed("Something happened with the server.");
        languagesPage.languageCardTag(maxCharLength).shouldNotBe(Condition.exist);
    }
    @Test(description = "Adds 6 languages and verifies they are displayed as cardTags in the component", priority = 4)
    public void addLanguages() {
        login();
        languagesPage.addLanguage("English", BASIC);
        languagesPage.checkToastIsDisplayed("Language successfully saved");
        languagesPage.languageCardTag("English").shouldBe(Condition.visible);
        languagesPage.addLanguage("Spanish", INTERMEDIATE);
        languagesPage.checkToastIsDisplayed("Language successfully saved");
        languagesPage.languageCardTag("Spanish").shouldBe(Condition.visible);
        languagesPage.addLanguage("Polish", ADVANCED);
        languagesPage.checkToastIsDisplayed("Language successfully saved");
        languagesPage.languageCardTag("Polish").shouldBe(Condition.visible);
        languagesPage.addLanguage("French", NATIVE);
        languagesPage.checkToastIsDisplayed("Language successfully saved");
        languagesPage.languageCardTag("French").shouldBe(Condition.visible);
    }
    @Test(description = "Deletes added languages", priority = 5)
    public void deleteLanguages() {
        login();
        languagesPage.deleteLanguage("English");
        languagesPage.deleteLanguage("Spanish");
        languagesPage.deleteLanguage("Polish");
        languagesPage.deleteLanguage("French");
    }
    //TODO activate this test once the bahavior is defined and add the proper error handling
    @Test(description = "Verifies user cannot add the same language more than once", priority = 6, enabled = false)
    public void addSameLanguageTwice() {
        login();
        languagesPage.addLanguage("Klingon", BASIC);
        languagesPage.checkToastIsDisplayed("Language successfully saved");
        languagesPage.languageCardTag("Klingon").shouldBe(Condition.visible);
        languagesPage.addLanguage("Klingon", BASIC);
        languagesPage.checkToastIsDisplayed("ErrorMessage");
    }
}

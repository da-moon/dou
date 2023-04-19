package tests;

import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
@Listeners
public class InterestsTest extends BaseTest{
    @Test(priority = 1, description = "Attempts to add an intest, but then cancels and verifes the interest was not added")
    public void verifyCancelButtonDiscardsChanges() {
        login();
        interestsPage.verifyCancelButtonDiscardContent("Canceling interest");
    }
    @Test(priority = 2, description = "Adds 6 interests and verifies the limit")
    public void addInterest() {
        login();
        interestsPage.createInterest("Interest 1");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 1");
        interestsPage.createInterest("Interest 2");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 2");
        interestsPage.createInterest("Interest 3");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 3");
        interestsPage.createInterest("Interest 4");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 4");
        interestsPage.createInterest("Interest 5");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 5");
        interestsPage.createInterest("Interest 6");
        interestsPage.checkToastIsDisplayed("Interest successfully saved");
        interestsPage.verifyInterestIsVisible("Interest 6");
        interestsPage.verifyInterestLimit();
    }
    @Test(priority = 3, description = "Deletes the created interest")
    public void deleteAllInterests() {
        login();
        interestsPage.deleteInterest("Interest 6");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
        interestsPage.deleteInterest("Interest 5");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
        interestsPage.deleteInterest("Interest 4");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
        interestsPage.deleteInterest("Interest 3");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
        interestsPage.deleteInterest("Interest 2");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
        interestsPage.deleteInterest("Interest 1");
        interestsPage.checkToastIsDisplayed("Interest successfully deleted");
    }
    @Test(priority = 4, description = "Attempts to add an interest with more than the max lenght allowed and verifies the error")
    public void verifiesMaxCharacterInterestError() {
        login();
        interestsPage.createInterest(maxCharLength);
        interestsPage.checkToastIsDisplayed("Something happened with the server.");
    }
}

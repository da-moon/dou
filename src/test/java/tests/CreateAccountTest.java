package tests;

import org.testng.annotations.Test;
public class CreateAccountTest extends BaseTest {
    final String CREATE_ACCOUNT = "/sign-up";
    @Test(description = "Creates an account, will fail if the account already exists")
    public void createAccountTest() throws InterruptedException {
        createAccountPage.open(CREATE_ACCOUNT);
        createAccountPage.fillFormAndSubmit(
                properties.getProperty("NAME"),
                properties.getProperty("LAST_NAME"),
                properties.getProperty("EMAIL"),
                properties.getProperty("TITLE"),
                properties.getProperty("COUNTRY"),
                properties.getProperty("PASSWORD"));
        createAccountPage.verifyTechMLogoIsPresent();
        createAccountPage.verifyAccountInfoIsPresent();
    }
}

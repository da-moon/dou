package tests;

import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
@Listeners
public class LoginTest extends BaseTest {

    @Test(description = "Test the login feature with existing user")
    public void loginTest() {
        login();
        loginPage.verifyTechMLogoIsPresent();
    }
}

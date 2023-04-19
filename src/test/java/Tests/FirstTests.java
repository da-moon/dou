package Tests;

import Pages.DressesPage;
import Pages.HomePage;
import Pages.LoginPage;
import Pages.ShoppingCartPage;
import org.testng.annotations.Test;

public class FirstTests extends BaseTest{

    @Test
    public void validateHomePageActive(){
        HomePage homePage = new HomePage(driver);
        homePage.validateLogo();
    }

    @Test(enabled = false)
    public void addToCartItem(){
        HomePage homePage = new HomePage(driver);
        homePage.validateLogo();
        homePage.goToDresses();

        DressesPage dressesPage = new DressesPage(driver);
        dressesPage.goToCasualDresses();
        dressesPage.selectCasualDress();
        dressesPage.proceedToCheckout();

    }
    @Test(enabled = false)
    public void validLogin(){
        HomePage homePage = new HomePage(driver);
        homePage.goToLogin();

        LoginPage loginPage = new LoginPage(driver);
        loginPage.enterUsername("victor.carrillo29@hotmail.com");
        loginPage.enterPassword("test123");
        loginPage.clickSignIn();
        loginPage.validateLogin();
    }

    @Test
    public void shopWorkFlow(){
        HomePage homePage = new HomePage(driver);
        homePage.goToLogin();

        LoginPage loginPage = new LoginPage(driver);
        loginPage.enterUsername("victor.carrillo29@hotmail.com");
        loginPage.enterPassword("test123");
        loginPage.clickSignIn();
        loginPage.validateLogin();
        loginPage.goToDressesFromLogin();

        DressesPage dressesPage = new DressesPage(driver);
        dressesPage.goToCasualDresses();
        dressesPage.selectCasualDress();
        dressesPage.proceedToCheckout();

        ShoppingCartPage shoppingCartPage = new ShoppingCartPage(driver);
        shoppingCartPage.proceedToCheckout();
        shoppingCartPage.validateAddress();
        shoppingCartPage.acceptAgreementTerms();
        shoppingCartPage.verifyShoppingCart();



    }
}

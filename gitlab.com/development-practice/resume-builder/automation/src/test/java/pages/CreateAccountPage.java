package pages;

import com.codeborne.selenide.Condition;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.By;
import tests.BaseTest;

import java.time.Duration;

import static com.codeborne.selenide.Selenide.$;
import static com.codeborne.selenide.Selenide.$x;

public class CreateAccountPage extends BasePage {
    SelenideElement nameField = $(By.id("firstName"));
    SelenideElement lastNameField = $(By.id("lastName"));
    SelenideElement emailField = $(By.id("email"));
    SelenideElement titleField = $(By.id("title"));
    SelenideElement countryField = $(By.id("country"));
    SelenideElement passwordField = $(By.id("password"));
    SelenideElement agreementCheckbox = $(By.xpath("//input[@type=\"checkbox\"]"));
    SelenideElement createAccountButton = $(By.xpath("//button[text()=\"CREATE ACCOUNT\"]"));
    SelenideElement techMLogo = $(By.xpath("//*[@alt=\"TechMLogo\"]"));
    public void fillFormAndSubmit(String name, String last_name, String email, String title, String country, String password) {
        nameField.sendKeys(name);
        lastNameField.sendKeys(last_name);
        emailField.sendKeys(email);
        titleField.sendKeys(title);
        countryField.sendKeys(country);
        passwordField.sendKeys(password);
        agreementCheckbox.click();
        createAccountButton.click();
    }
    public void verifyTechMLogoIsPresent() {
        techMLogo.shouldBe(Condition.visible, Duration.ofSeconds(10));
    }
    public void verifyAccountInfoIsPresent() {
        getElementByText("\"" + BaseTest.properties.getProperty("NAME") + " " + BaseTest.properties.getProperty("LAST_NAME") + "\"").shouldBe(Condition.visible);
        getElementByText("\"" + BaseTest.properties.getProperty("TITLE") + "\"").shouldBe(Condition.visible);
        getElementByText("\"" + BaseTest.properties.getProperty("COUNTRY") + "\"").shouldBe(Condition.visible);
    }
    public SelenideElement getElementByText(String elementText) {
        return $x("//*[text()=" + elementText + "]");
    }
}

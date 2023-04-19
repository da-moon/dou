package pages;

import com.codeborne.selenide.Condition;
import com.codeborne.selenide.Selenide;
import com.codeborne.selenide.SelenideElement;
import org.openqa.selenium.By;

import static com.codeborne.selenide.Selenide.$;
import static com.codeborne.selenide.Selenide.$x;

public abstract class BasePage {

    //Login elements
    public SelenideElement emailField = $(By.xpath("//*[@id=\"email\"]"));
    public SelenideElement passwordField = $(By.xpath("//*[@id=\"password\"]"));
    public SelenideElement loginButton = $(By.xpath("//button[text()=\"LOGIN\"]"));
    SelenideElement techMLogo = $(By.xpath("//*[@alt=\"TechMLogo\"]"));

    //Toast elements
    SelenideElement toast = $(By.xpath("//*[contains(@class, \"MuiAlert-message\")]"));
    SelenideElement saveButton = $x("//button[text()=\"Save\"]");
    SelenideElement cancelButton = $x("//button[text()=\"Cancel\"]");
    SelenideElement deleteButton = $(By.xpath("//button[text()=\"Delete\"]"));


    /**
     * Method for checking the toast notification after saving any change, receives a string as parameter
     *
     * @param message String to compare with actual toast message
     */
    public void checkToastIsDisplayed(String message){
        toast.shouldBe(Condition.visible);
        toast.shouldBe(Condition.text(message));
    }

    public void verifyTechMLogoIsPresent() {
        techMLogo.shouldBe(Condition.visible);
    }
    /**
     * @param path is concatenated after uri on env.properties
     */
    public void open(String path) {
        Selenide.open(path);
    }
}

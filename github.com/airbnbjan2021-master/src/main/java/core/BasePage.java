package core;

import io.appium.java_client.MobileElement;
import io.appium.java_client.TouchAction;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.AndroidKeyCode;
import io.appium.java_client.android.nativekey.AndroidKey;
import io.appium.java_client.android.nativekey.KeyEvent;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.touch.WaitOptions;
import io.appium.java_client.touch.offset.PointOption;
import org.omg.CORBA.TIMEOUT;
import org.openqa.selenium.*;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.pagefactory.AjaxElementLocatorFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

public class BasePage {

    protected AndroidDriver driver;
    private WebDriverWait wait;

    public enum Direction {
        UP,
        DOWN,
        LEFT,
        RIGHT;
    }

    public BasePage(AndroidDriver driver) {
        this.driver = driver;
        PageFactory.initElements(new AppiumFieldDecorator(driver, Duration.ofSeconds(60L)), this);
    }

    /**
     * Tap back method
     */
    public void tapBack(){
        System.out.println("Trying to tap back on device...");
        driver.pressKey(new KeyEvent(AndroidKey.BACK));
        System.out.println("Back button tapped.");
    }

    /**
     * Tap Home method
     */
    public void tapHome(){
        System.out.println("Trying to tap home on device...");
        driver.pressKey(new KeyEvent(AndroidKey.HOME));
        System.out.println("Home button tapped.");
    }

    /**
     * Tap Settings method
     */
    public void tapSetings(){
        System.out.println("Trying to tap Settings on device...");
        driver.pressKey(new KeyEvent(AndroidKey.SETTINGS));
        System.out.println("Settings button tapped.");
    }

    /**
     * Swipe to element method
     * @param locator - locatorID
     */
    public void swipeToElementById(String locator){
        System.out.println("Trying to find the element...");

        driver.manage().timeouts().implicitlyWait(3, TimeUnit.SECONDS);

        int contador = 0;

        while (driver.findElements(By.id(locator)).size() == 0 && contador < 10){
            System.out.println("Element wasn't found, swiping down...");

            // Animation default time:
            //  - Android: 300 ms
            //  - iOS: 200 ms
            // final value depends on your app and could be greater
            final int ANIMATION_TIME = 200; // ms
            final int PRESS_TIME = 200; // ms
            int edgeBorder = 10; // better avoid edges
            PointOption pointOptionStart, pointOptionEnd;

            // init screen variables
            Dimension dims = driver.manage().window().getSize();

            // init start point = center of screen
            pointOptionStart = PointOption.point(dims.width / 2, dims.height / 2);
            pointOptionEnd = PointOption.point(dims.width / 2, edgeBorder);
            System.out.println("Position to swipe created.");

            // execute swipe using TouchAction
            try {
                new TouchAction(driver)
                        .press(pointOptionStart)
                        // a bit more reliable when we add small wait
                        .waitAction(WaitOptions.waitOptions(Duration.ofMillis(PRESS_TIME)))
                        .moveTo(pointOptionEnd)
                        .release().perform();
                System.out.println("Swipe performed.");
            } catch (Exception e) {
                System.err.println("swipeScreen(): TouchAction FAILED\n" + e.getMessage());
                return;
            }

            // always allow swipe action to complete
            try {
                Thread.sleep(ANIMATION_TIME);
            } catch (InterruptedException e) {
                // ignore
            }
            contador++;
        }
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    }

    /**
     * Swipe to element method
     * @param locator - locatorID
     */
    public void swipeToElementByXpath(String locator) throws InterruptedException {
        System.out.println("Trying to find the element...");

        driver.manage().timeouts().implicitlyWait(3, TimeUnit.SECONDS);

        int contador = 0;

        while (driver.findElements(By.xpath(locator)).size() == 0 && contador < 10){
            System.out.println("Element wasn't found, swiping down...");

            // Animation default time:
            //  - Android: 300 ms
            //  - iOS: 200 ms
            // final value depends on your app and could be greater
            final int ANIMATION_TIME = 200; // ms
            final int PRESS_TIME = 200; // ms
            int edgeBorder = 10; // better avoid edges
            PointOption pointOptionStart, pointOptionEnd;

            // init screen variables
            Dimension dims = driver.manage().window().getSize();

            // init start point = center of screen
            pointOptionStart = PointOption.point(dims.width / 2, dims.height / 2);
            pointOptionEnd = PointOption.point(dims.width / 2, edgeBorder);
            System.out.println("Position to swipe created.");

            // execute swipe using TouchAction
            try {
                new TouchAction(driver)
                        .press(pointOptionStart)
                        // a bit more reliable when we add small wait
                        .waitAction(WaitOptions.waitOptions(Duration.ofMillis(PRESS_TIME)))
                        .moveTo(pointOptionEnd)
                        .release().perform();
                System.out.println("Swipe performed.");
            } catch (Exception e) {
                System.err.println("swipeScreen(): TouchAction FAILED\n" + e.getMessage());
                return;
            }

            // always allow swipe action to complete
            try {
                Thread.sleep(ANIMATION_TIME);
            } catch (InterruptedException e) {
                // ignore
            }
            contador++;
        }
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    }

    /**
     * Performs swipe from the center of screen
     *
     * @param dir the direction of swipe
     * @version java-client: 7.3.0
     **/
    public void swipeScreen(Direction dir) {
        System.out.println("swipeScreen(): dir: '" + dir + "'"); // always log your actions

        // Animation default time:
        //  - Android: 300 ms
        //  - iOS: 200 ms
        // final value depends on your app and could be greater
        final int ANIMATION_TIME = 200; // ms

        final int PRESS_TIME = 200; // ms

        int edgeBorder = 10; // better avoid edges
        PointOption pointOptionStart, pointOptionEnd;

        // init screen variables
        Dimension dims = driver.manage().window().getSize();

        // init start point = center of screen
        pointOptionStart = PointOption.point(dims.width / 2, dims.height / 2);

        switch (dir) {
            case DOWN: // center of footer
                pointOptionEnd = PointOption.point(dims.width / 2, dims.height - edgeBorder);
                break;
            case UP: // center of header
                pointOptionEnd = PointOption.point(dims.width / 2, edgeBorder);
                break;
            case LEFT: // center of left side
                pointOptionEnd = PointOption.point(edgeBorder, dims.height / 2);
                break;
            case RIGHT: // center of right side
                pointOptionEnd = PointOption.point(dims.width - edgeBorder, dims.height / 2);
                break;
            default:
                throw new IllegalArgumentException("swipeScreen(): dir: '" + dir + "' NOT supported");
        }

        // execute swipe using TouchAction
        try {
            new TouchAction(driver)
                    .press(pointOptionStart)
                    // a bit more reliable when we add small wait
                    .waitAction(WaitOptions.waitOptions(Duration.ofMillis(PRESS_TIME)))
                    .moveTo(pointOptionEnd)
                    .release().perform();
        } catch (Exception e) {
            System.err.println("swipeScreen(): TouchAction FAILED\n" + e.getMessage());
            return;
        }

        // always allow swipe action to complete
        try {
            Thread.sleep(ANIMATION_TIME);
        } catch (InterruptedException e) {
            // ignore
        }
    }

    /**
     * Performs swipe from the center of screen n times
     *
     * @param dir the direction of swipe
     * @version java-client: 7.3.0
     **/
    public void swipeScreen(Direction dir, int times) {
        for(int i = 0; i < times; i++){
            swipeScreen(dir);
        }
    }



    /**
     * Performs swipe inside an element
     *
     * @param el  the element to swipe
     * @param dir the direction of swipe
     * @version java-client: 7.3.0
     **/
    public void swipeElementAndroid(MobileElement el, Direction dir) {
        System.out.println("swipeElementAndroid(): dir: '" + dir + "'"); // always log your actions

        // Animation default time:
        //  - Android: 300 ms
        //  - iOS: 200 ms
        // final value depends on your app and could be greater
        final int ANIMATION_TIME = 200; // ms

        final int PRESS_TIME = 200; // ms

        int edgeBorder;
        PointOption pointOptionStart, pointOptionEnd;

        // init screen variables
        Rectangle rect = el.getRect();
        // sometimes it is needed to configure edgeBorders
        // you can also improve borders to have vertical/horizontal
        // or left/right/up/down border variables
        edgeBorder = 0;

        switch (dir) {
            case DOWN: // from up to down
                pointOptionStart = PointOption.point(rect.x + rect.width / 2,
                        rect.y + edgeBorder);
                pointOptionEnd = PointOption.point(rect.x + rect.width / 2,
                        rect.y + rect.height - edgeBorder);
                break;
            case UP: // from down to up
                pointOptionStart = PointOption.point(rect.x + rect.width / 2,
                        rect.y + rect.height - edgeBorder);
                pointOptionEnd = PointOption.point(rect.x + rect.width / 2,
                        rect.y + edgeBorder);
                break;
            case LEFT: // from right to left
                pointOptionStart = PointOption.point(rect.x + rect.width - edgeBorder,
                        rect.y + rect.height / 2);
                pointOptionEnd = PointOption.point(rect.x + edgeBorder,
                        rect.y + rect.height / 2);
                break;
            case RIGHT: // from left to right
                pointOptionStart = PointOption.point(rect.x + edgeBorder,
                        rect.y + rect.height / 2);
                pointOptionEnd = PointOption.point(rect.x + rect.width - edgeBorder,
                        rect.y + rect.height / 2);
                break;
            default:
                throw new IllegalArgumentException("swipeElementAndroid(): dir: '" + dir + "' NOT supported");
        }

        // execute swipe using TouchAction
        try {
            new TouchAction(driver)
                    .press(pointOptionStart)
                    // a bit more reliable when we add small wait
                    .waitAction(WaitOptions.waitOptions(Duration.ofMillis(PRESS_TIME)))
                    .moveTo(pointOptionEnd)
                    .release().perform();
        } catch (Exception e) {
            System.err.println("swipeElementAndroid(): TouchAction FAILED\n" + e.getMessage());
            return;
        }

        // always allow swipe action to complete
        try {
            Thread.sleep(ANIMATION_TIME);
        } catch (InterruptedException e) {
            // ignore
        }
    }

    protected void waitForElementToAppear(By locator) {
        wait.until(ExpectedConditions.elementToBeClickable(locator));
    }

    protected void waitForElementToBeVisible(WebElement element) {
        wait.until(ExpectedConditions.visibilityOf(element));
    }

    protected void waitForElementToDisappear(By locator) {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    protected void waitForTextToDisappear(By locator, String text) {
        wait.until(ExpectedConditions.not(ExpectedConditions.textToBe(locator, text)));
    }

    /**
     * Check if Web element is present
     * @author Ivan Rivas
     * @param element
     */
    protected void waitForElementToAppear(WebElement element) {
        wait.until(ExpectedConditions.visibilityOf(element));
    }

    /**
     * Get element attribute method
     * @param element - Web element
     * @param attribute - desired attribute
     * @return attribute value
     */
    protected String getAttributeValue(WebElement element, String attribute){
        return element.getAttribute(attribute);
    }

    /**
     * Check if Web element is clickeable
     * @author Ivan Rivas
     * @param element
     */
    protected void waitForElementToBeClickable(WebElement element) {
        wait.until(ExpectedConditions.elementToBeClickable(element));
    }

    /**
     * Wait for an element to not be present
     * @author Ivan Rivas
     * @param element
     */
    protected void waitForElementToDisappear(WebElement element) {
        wait.until(ExpectedConditions.invisibilityOf(element));
    }

    /**
     * Check method to see if element is present
     * @param locator
     * @return
     */
    protected boolean isElementPresent(By locator){
        System.out.println("Checking if element is present...");
        if(driver.findElements(locator).size() > 0) {
            System.out.println("Element is present");
            return true;
        }
        else {
            System.out.println("Element is not present");
            return false;
        }
    }
}

package Utility;


import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;

import java.util.List;

public class LocatorsRepository {

    private String exitPopUp = "button[class='_2AkmmA _29YdH8']";
    private String inputTextField = "input[type='text']";
    private String searchButton = "button[type='submit']";
    private String desiredResult = "a[title*='AKG K240 STUDIO HEADPHONE Wired Headphone']";
    private String results = "a[class='_2cLu-l']";
    private String addToCartButton = "button[class='_2AkmmA _2Npkh4 _2MWPVK']";
    private String placerOrderButton= "button[class='_2AkmmA iwYpF9 _7UHT_c']";


    public String getExitPopUp(){
        return exitPopUp;
    }

   public String getInputTextField(){
        return inputTextField;
   }

    public String getSearchButton(){
        return searchButton;
    }

    public String getDesiredResult(){
        return desiredResult;
    }

    public String getResults(){
        return results;
    }

    public String getAddToCartButton(){
        return addToCartButton;
    }

    public String getPlacerOrderButton(){
        return placerOrderButton;
    }
}

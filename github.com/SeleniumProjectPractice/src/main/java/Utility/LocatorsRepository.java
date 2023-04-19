package Utility;


public class LocatorsRepository {


    private String cssHomeLogo = "div[id='header_logo']";
    private String cssAddToCartButton = "a[class='button ajax_add_to_cart_button btn btn-default']";
    private String cssDressesMenu = "div[id='block_top_menu']>ul>li>a[title='Dresses']";
    private String cssCasualDressesMenu = "#categories_block_left>div>ul>li:nth-child(1)";
    private String cssItemCasualDress = "div[id='center_column']>ul>li";
    private String cssProccedToCheckout = "a[class='btn btn-default button button-medium']";

    private String cssLoginButton = "a[class='login']";
    private String cssInputFieldUsername = "input[id='email']";
    private String cssInputFieldPassword = "input[id='passwd']";
    private String cssSignInButton = "button[id='SubmitLogin']";
    private String cssCustomerAccountButton = "a[title='View my customer account']";

    private String cssShoppingCheckout = "a[class='button btn btn-default standard-checkout button-medium']";
    private String cssAddressBox = "ul[class='address item box']";
    private String cssProcessAddress = "button[name='processAddress']";
    private String cssAgreementTerms = "input[id='cgv']";
    private String cssProcessCarrier = "button[name='processCarrier']";
    private String cssCartNumber = "table[id='cart_summary']>tbody";

    public String getCssHomeLogo() {
        return cssHomeLogo;
    }

    public String getCssDressesMenu() {
        return cssDressesMenu;
    }

    public String getCssCasualDressesMenu() {
        return cssCasualDressesMenu;
    }

    public String getCssItemCasualDress() {
        return cssItemCasualDress;
    }

    public String getCssAddToCartButton() {
        return cssAddToCartButton;
    }

    public String getCssProccedToCheckout() {
        return cssProccedToCheckout;
    }

    public String getCssLoginButton() {
        return cssLoginButton;
    }

    public String getCssInputFieldUsername() {
        return cssInputFieldUsername;
    }

    public String getCssInputFieldPassword() {
        return cssInputFieldPassword;
    }

    public String getCssSignInButton() {
        return cssSignInButton;
    }

    public String getCssCustomerAccountButton() {
        return cssCustomerAccountButton;


    }

    public String getCssShoppingCheckout() {
        return cssShoppingCheckout;
    }

    public String getCssAddressBox() {
        return cssAddressBox;
    }

    public String getCssProcessAddress() {
        return cssProcessAddress;
    }

    public String getCssAgreementTerms() {
        return cssAgreementTerms;
    }

    public String getCssProcessCarrier() {
        return cssProcessCarrier;
    }

    public String getCssCartNumber() {
        return cssCartNumber;
    }


}

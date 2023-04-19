package com.dou.sample.ecommerce.cart.dto;

import java.util.HashMap;
import java.util.Map;

public class CreateCartRequest {
    private String userName;
    private Map<String, Integer> products = new HashMap<>();

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Map<String, Integer> getProducts() {
        return products;
    }

    public void setProducts(Map<String, Integer> products) {
        this.products = products;
    }
}

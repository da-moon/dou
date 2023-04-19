package com.dou.sample.ecommerce.cart.domain;

import java.util.ArrayList;
import java.util.List;

public class Cart {

    private String uuid;
    private User user;
    private List<CartEntry> entries = new ArrayList<>();

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<CartEntry> getEntries() {
        return entries;
    }

    public void setEntries(List<CartEntry> entries) {
        this.entries = entries;
    }
}

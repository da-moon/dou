package com.dou.sample.ecommerce.cart.controllers;

import com.dou.sample.ecommerce.cart.config.ServiceProperties;
import com.dou.sample.ecommerce.cart.domain.Cart;
import com.dou.sample.ecommerce.cart.domain.CartEntry;
import com.dou.sample.ecommerce.cart.domain.Product;
import com.dou.sample.ecommerce.cart.domain.User;
import com.dou.sample.ecommerce.cart.dto.CreateCartRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@RestController
public class CartController {

    private final ServiceProperties serviceProperties;
    private final Map<String, Cart> carts = new ConcurrentHashMap<>();

    @Autowired
    public CartController(ServiceProperties serviceProperties) {
        this.serviceProperties = serviceProperties;
    }

    @PostMapping("/cart")
    public Cart createCart(@RequestBody CreateCartRequest request) {
        RestTemplate restTemplate = new RestTemplateBuilder().build();
        User user = restTemplate.getForObject(serviceProperties.getUserUrl() + "/users/{userName}", User.class, request.getUserName());

        List<CartEntry> cartEntries = request.getProducts().entrySet().stream()
                .map(e -> {
                    Product product = restTemplate.getForObject(serviceProperties.getCatalogUrl() + "/products/{id}", Product.class, e.getKey());
                    return new CartEntry(product, e.getValue());
                })
                .collect(Collectors.toList());

        Cart cart = new Cart();
        cart.setUuid(UUID.randomUUID().toString());
        cart.setUser(user);
        cart.setEntries(cartEntries);
        carts.put(cart.getUuid(), cart);
        return cart;
    }

    @PutMapping("/cart/{cartId}/checkout")
    public void checkout(@PathVariable("cartId") String cartUuid) {
        RestTemplate restTemplate = new RestTemplateBuilder().build();
        Cart cart = carts.get(cartUuid);
        cart.getEntries().stream()
                .map(e -> {
                    Product p = e.getProduct();
                    p.setStockAvailable(p.getStockAvailable() - e.getQuantity());
                    return p;
                })
                .forEach(p -> restTemplate.put(serviceProperties.getCatalogUrl() + "/products/{id}", p, p.getUuid()));
    }

}

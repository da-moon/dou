package com.dou.sample.ecommerce.catalog.controllers;

import com.dou.sample.ecommerce.catalog.domain.Product;
import com.dou.sample.ecommerce.catalog.repositories.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CatalogController {

    private BookRepository bookRepository;

    @Autowired
    public CatalogController(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @GetMapping("/products")
    public List<Product> listProducts() {
        return bookRepository.findAll();
    }

    @GetMapping("/products/{id}")
    public Product getById(@PathVariable("id") String uuid) {
        return bookRepository.findById(uuid).get();
    }

    @PutMapping("/products/{id}")
    public void updateStock(@PathVariable("id") String uuid, @RequestBody Product newProduct) {
        Product product = bookRepository.findById(uuid).get();
        product.setStockAvailable(newProduct.getStockAvailable());
        bookRepository.save(product);
    }

}

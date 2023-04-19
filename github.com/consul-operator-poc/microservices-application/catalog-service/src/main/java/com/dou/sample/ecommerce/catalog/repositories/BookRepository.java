package com.dou.sample.ecommerce.catalog.repositories;

import com.dou.sample.ecommerce.catalog.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends JpaRepository<Product, String> {
}

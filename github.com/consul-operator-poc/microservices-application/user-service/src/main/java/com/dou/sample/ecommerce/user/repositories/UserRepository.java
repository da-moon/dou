package com.dou.sample.ecommerce.user.repositories;

import com.dou.sample.ecommerce.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
}

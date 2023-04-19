package com.dou.sample.ecommerce.user.controllers;

import com.dou.sample.ecommerce.user.domain.User;
import com.dou.sample.ecommerce.user.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController {

    private final UserRepository userRepository;

    @Autowired
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/users")
    public List<User> listUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/users/{userName}")
    public @ResponseBody User getByName(@PathVariable("userName") String userName) {
        return userRepository.findById(userName).get();
    }
}

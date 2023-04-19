package com.example.securingweb;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
public class HelloController {

    @Autowired
    GreetingService service;

    @GetMapping("greeting")
    public String greeting(Principal principal) {
        return "Hello " + principal.getName();
    }


    @GetMapping("v1/greeting")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String greetingV1(Principal principal) {
        return "Hello v1 " + principal.getName();
    }


    @GetMapping("v2/greeting")
    public String greetingV2(Principal principal) {
        return service.greeting(principal);
    }
}

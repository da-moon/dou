package com.example.securingweb;

import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.security.Principal;

@Service
public class GreetingService {

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String greeting(Principal principal) {
        System.out.println("GreetingService.greeting executed");
        return "Hello service " + principal.getName();
    }
}

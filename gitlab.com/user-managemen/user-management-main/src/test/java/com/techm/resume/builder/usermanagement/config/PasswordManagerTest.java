package com.techm.resume.builder.usermanagement.config;

import org.springframework.security.crypto.password.PasswordEncoder;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PasswordManagerTest {

    private PasswordEncoder passwordEncoder;

    public PasswordManagerTest() {
    }

    @BeforeEach
    public void init() {
        this.passwordEncoder = new PasswordManager().passwordEncoder();
    }

    @Test
    public void passwordManagerEncodeTest() {
        assertEquals("f9ec1db33e2c5a7535d8292429031cbe", this.passwordEncoder.encode("rawPassword"));
        assertEquals("08fce993c4b86368b3961e685011677d", this.passwordEncoder.encode("SuperPassword123@"));
    }

    @Test
    public void passwordManagerMatchesTest() {
        assertTrue(this.passwordEncoder.matches("SuperPassword123@", "08fce993c4b86368b3961e685011677d"));
    }
}

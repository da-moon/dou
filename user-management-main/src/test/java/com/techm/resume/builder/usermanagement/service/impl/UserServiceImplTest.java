package com.techm.resume.builder.usermanagement.service.impl;

import com.techm.resume.builder.usermanagement.api.request.LoginRequest;
import com.techm.resume.builder.usermanagement.api.request.NewUserRequest;
import com.techm.resume.builder.usermanagement.dto.UserDto;
import com.techm.resume.builder.usermanagement.entity.Role;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class UserServiceImplTest {

    @Autowired
    private UserServiceImpl userServiceImpl;

    private LoginRequest loginRequest;
    private NewUserRequest newUserRequest;

    public UserServiceImplTest() {
    }

    @BeforeEach
    public void init() {
        this.setLoginRequest();
        this.setNewUserRequest();
    }

    private void setLoginRequest() {
        this.loginRequest = new LoginRequest();
        this.loginRequest.setEmail("juan@digital.com");
        this.loginRequest.setPassword("Pas123");
    }

    private void setNewUserRequest() {
        this.newUserRequest = new NewUserRequest();
        this.newUserRequest.setEmail("juan@digital.com");
        this.newUserRequest.setFirstName("Juan Pablo");
        this.newUserRequest.setLastName("Guitron");
        this.newUserRequest.setPassword("Pas123");
        this.newUserRequest.setRole(Role.ADMIN);
    }

    public static String generateRandomEmail(String emailDomain) {
        return String.format("test-%s@%s", System.currentTimeMillis() / 1000, emailDomain);
    }

    @Test
    void getUserTest() {
        final UserDto createdUser;
        final UUID userId;
        final UserDto getUser;
        final String generatedString = generateRandomEmail("techmahindra.com");

        this.newUserRequest.setEmail(generatedString);

        createdUser = this.userServiceImpl.createNewUser(this.newUserRequest);
        userId = createdUser.getUserId();
        getUser = this.userServiceImpl.getUser(userId);

        assertEquals(createdUser, getUser);
    }

    @Test
    void getUserFailTest() {
        final Throwable exceptionGet = assertThrows(ResponseStatusException.class,
                () -> this.userServiceImpl.getUser(UUID.randomUUID()));
        assertEquals("404 NOT_FOUND \"User not found\"", exceptionGet.getMessage());
    }

    @Test
    void loginUserTest() {
        final UserDto createdUser;
        final UserDto loginUser;
        final String generatedString = generateRandomEmail("techmahindra2.com");

        this.newUserRequest.setEmail(generatedString);
        this.loginRequest.setEmail(generatedString);

        createdUser = this.userServiceImpl.createNewUser(this.newUserRequest);
        loginUser = this.userServiceImpl.login(this.loginRequest);

        assertEquals(createdUser, loginUser);
    }

    @Test
    void loginUserFailTest() {
        final String generatedString = generateRandomEmail("techmahindra3.com");

        this.newUserRequest.setEmail(generatedString);
        this.loginRequest.setEmail(generatedString);
        this.userServiceImpl.createNewUser(this.newUserRequest);

        //should fail when password is Invalid
        this.loginRequest.setPassword("bad");
        final Throwable exceptionLogin = assertThrows(ResponseStatusException.class,
                () -> this.userServiceImpl.login(this.loginRequest));
        assertEquals("401 UNAUTHORIZED \"Invalid username/password supplied\"", exceptionLogin.getMessage());

        //should fail when email is invalid
        this.loginRequest.setEmail("Invalid@email.com");
        final Throwable exceptionLogin2 = assertThrows(ResponseStatusException.class,
                () -> this.userServiceImpl.login(this.loginRequest));
        assertEquals("401 UNAUTHORIZED \"Invalid username/password supplied\"", exceptionLogin2.getMessage());
    }

    @Test
    void createNewUserTest() {
        final String generatedString = generateRandomEmail("techmahindra4.com");
        final UserDto createdUser;

        this.newUserRequest.setEmail(generatedString);
        createdUser = this.userServiceImpl.createNewUser(this.newUserRequest);

        assertNotNull(createdUser);
    }

    @Test
    void createNewUserFailTest() {
        final String generatedString = generateRandomEmail("techmahindra5.com");

        this.newUserRequest.setEmail(generatedString);
        this.userServiceImpl.createNewUser(this.newUserRequest);

        final Throwable exception = assertThrows(ResponseStatusException.class,
                () -> this.userServiceImpl.createNewUser(this.newUserRequest));
        assertEquals("409 CONFLICT \"Duplicated email\"", exception.getMessage());
    }
}

/**
 * This file is the main entry point.
 *
 * <p>Request/Methods: CreateNewUser and Login
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.api;

import com.techm.resume.builder.usermanagement.api.request.LoginRequest;
import com.techm.resume.builder.usermanagement.api.request.NewUserRequest;
import com.techm.resume.builder.usermanagement.dto.UserDto;
import com.techm.resume.builder.usermanagement.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.UUID;

/**
 * We define the endpoints that this MS has.
 */
@RestController
@RequestMapping("/users")
public class UserApi {

    private final transient UserService userService;

    public UserApi(final UserService userService) {
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<UserDto> createNewUser(@RequestBody @Valid final NewUserRequest request) {
        return ResponseEntity.ok(userService.createNewUser(request));
    }

    @PostMapping("/login")
    public ResponseEntity<UserDto> login(@RequestBody @Valid final LoginRequest loginRequest) {
        return ResponseEntity.ok(userService.login(loginRequest));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<UserDto> getUser(@PathVariable final UUID userId) {
        return ResponseEntity.ok(userService.getUser(userId));
    }

}

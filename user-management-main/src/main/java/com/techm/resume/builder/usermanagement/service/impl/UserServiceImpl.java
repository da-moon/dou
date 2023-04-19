/**
 * This file contains the user service implementation.
 *
 * <p>Methods: CreateNewUser, Login, MapUserToResource
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.service.impl;

import com.techm.resume.builder.usermanagement.api.request.LoginRequest;
import com.techm.resume.builder.usermanagement.api.request.NewUserRequest;
import com.techm.resume.builder.usermanagement.config.MappingConfig;
import com.techm.resume.builder.usermanagement.entity.UserEntity;
import com.techm.resume.builder.usermanagement.dto.UserDto;
import com.techm.resume.builder.usermanagement.repository.UserRepository;
import com.techm.resume.builder.usermanagement.service.UserService;
import lombok.extern.slf4j.Slf4j;

import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;
import java.util.UUID;

/**
 * We implement the user service.
 */
@Slf4j
@Service
public class UserServiceImpl implements UserService {

    private static final String INVALIDCREDENTIALS = "Invalid username/password supplied";

    private final transient UserRepository userRepository;
    private final transient ModelMapper modelMapper;
    private final transient PasswordEncoder passwordEncoder;

    public UserServiceImpl(
            final UserRepository userRepository,
            final MappingConfig mapperConfig,
            final PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.modelMapper = mapperConfig.mapper();
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public UserDto createNewUser(final NewUserRequest request) {
        log.info("Creating new user: {}", request);

        final Optional<UserEntity> foundUser = userRepository.findUserByEmail(request.getEmail());
        if (foundUser.isPresent()) {
            // Check if the email is already in use
            // if so, then thrown a response status exception with http code 409
            log.trace("Duplicated email!!!");
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Duplicated email");
        }

        // if the email is new, then create and save the new user
        final UserEntity user = modelMapper.map(request, UserEntity.class);

        // encrypt the user password
        final String encryptedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encryptedPassword);

        final UserEntity newUser = userRepository.save(user);
        return mapUserToResource(newUser);

    }

    @Override
    public UserDto login(final LoginRequest loginRequest) {
        final Optional<UserEntity> optUser = userRepository.findUserByEmail(loginRequest.getEmail());
        return optUser.map(user -> verifyPassword(user, loginRequest)).orElseThrow(() -> {
            return new ResponseStatusException(HttpStatus.UNAUTHORIZED, INVALIDCREDENTIALS);
        });
    }

    @Override
    public UserDto getUser(final UUID userId) {
        final Optional<UserEntity> optUser = userRepository.findById(userId);
        return optUser.map(this::mapUserToResource).orElseThrow(() -> {
            return new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        });
    }

    private UserDto mapUserToResource(final UserEntity user) {
        return modelMapper.map(user, UserDto.class);
    }

    private UserDto verifyPassword(final UserEntity user, final LoginRequest loginRequest) {
        final String md5Password = passwordEncoder.encode(loginRequest.getPassword());
        if (md5Password.equals(user.getPassword())) {
            return mapUserToResource(user);
        }
        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, INVALIDCREDENTIALS);
    }
}

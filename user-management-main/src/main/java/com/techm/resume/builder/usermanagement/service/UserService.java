/**
 * This file contains the user service interface.
 *
 * <p>Methods: CreateNewUser, Login
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.service;

import com.techm.resume.builder.usermanagement.api.request.LoginRequest;
import com.techm.resume.builder.usermanagement.api.request.NewUserRequest;
import com.techm.resume.builder.usermanagement.dto.UserDto;

import java.util.UUID;

/**
 * We define the user service methods for the creation and retrieving of the data.
 */
public interface UserService {

    UserDto createNewUser(NewUserRequest request);

    UserDto login(LoginRequest loginRequest);

    UserDto getUser(UUID userId);

}

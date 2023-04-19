/**
 * This file contains the data needed for the creation of a new user.
 *
 * <p>Data: Role, FirstName, LastName, Email, Password
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.api.request;

import javax.validation.constraints.NotNull;
import com.techm.resume.builder.usermanagement.entity.Role;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

/**
 * We define the data needed for the creation of a new user request.
 */
@Data
@NoArgsConstructor
public class NewUserRequest {

    @NotNull
    private Role role;

    @NotBlank
    private String firstName;

    @NotBlank
    private String lastName;

    @NotBlank
    private String email;

    @NotBlank
    private String password;

}

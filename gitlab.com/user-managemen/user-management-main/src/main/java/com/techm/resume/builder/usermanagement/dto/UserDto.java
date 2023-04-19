/**
 * This file contains the user data that is going to be expose to the world.
 *
 * <p>Data: Email, FirstName, LastName, Role
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * We define the user Data Transfer Object.
 */
@Data
@NoArgsConstructor
public class UserDto {

    private UUID userId;
    private String email;
    private String firstName;
    private String lastName;
    private String role;

}

/**
 * This file contains the user data that is going to be store in the DB.
 *
 * <p>Data: Id, Email, FirstName, LastName, Password, Role
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.entity;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.GeneratedValue;
import javax.persistence.Enumerated;
import javax.persistence.EnumType;
import java.util.UUID;

/**
 * We define the user entity data.
 */
@Getter
@Setter
@Entity
@Table(name = "user")
public class UserEntity {

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid2")
    @Column(name = "id", columnDefinition = "BINARY(16)", insertable = false, updatable = false, nullable = false)
    private UUID userId;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "password")
    private String password;

    @Column(name = "role")
    @Enumerated(EnumType.STRING)
    private Role role;

}

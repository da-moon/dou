package com.techM.OpenHouseLandingRest.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Entity
public class Attendant {

  @Id @GeneratedValue private Integer id;

  @NotNull
  @NotEmpty(message = "The name field is not optional")
  private String name;

  @Email(message = "Email should be valid")
  @Column(unique = true)
  @NotNull
  @NotEmpty(message = "The email field is not optional")
  private String email;

  @NotNull
  @NotEmpty(message = "The phone number field is not optional")
  private String phoneNumber;

  @NotNull
  @NotEmpty(message = "The role field is not optional")
  private String role;

  @NotNull
  @NotEmpty(message = "The location field is not optional")
  private String location;

  @NotNull
  @NotEmpty(message = "The company field is not optional")
  private String company;

  // Constructors
  public Attendant() {}

  public Attendant(
      Integer id,
      String name,
      String email,
      String phoneNumber,
      String role,
      String location,
      String company) {
    super();
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.role = role;
    this.location = location;
    this.company = company;
  }

  public Attendant(
      String name, String email, String phoneNumber, String role, String location, String company) {
    super();
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.role = role;
    this.location = location;
    this.company = company;
  }

  // Getters and Setters
  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getPhoneNumber() {
    return phoneNumber;
  }

  public void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  public String getRole() {
    return role;
  }

  public void setRole(String role) {
    this.role = role;
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

  public String getCompany() {
    return company;
  }

  public void setCompany(String company) {
    this.company = company;
  }
}

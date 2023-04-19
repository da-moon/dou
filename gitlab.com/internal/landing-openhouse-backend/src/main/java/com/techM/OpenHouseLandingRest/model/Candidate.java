package com.techM.OpenHouseLandingRest.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Entity
public class Candidate {

  @Id @GeneratedValue private Integer id;

  @NotNull(message = "The name field is not optional")
  @NotEmpty(message = "The name field is not optional")
  private String name;

  @Email(message = "Email should be valid")
  @Column(unique = true)
  @NotNull(message = "The email field is not optional")
  @NotEmpty(message = "The email field is not optional")
  private String email;

  @Column(unique = true)
  @NotNull(message = "The contact Number field is not optional")
  @NotEmpty(message = "The contact Number field is not optional")
  private String contactNumber;

  @NotNull(message = "The Programming language of interest field is not optional")
  @NotEmpty(message = "The Programming language of interest field is not optional")
  private String programmingLanguage;

  @NotNull(message = "The LinkedIn field is not optional")
  @NotEmpty(message = "The LinkedIn field is not optional")
  private String linkedIn;

  // Constructors
  public Candidate() {}

  public Candidate(
      Integer id,
      String name,
      String email,
      String contactNumber,
      String programmingLanguage,
      String linkedIn) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.contactNumber = contactNumber;
    this.programmingLanguage = programmingLanguage;
    this.linkedIn = linkedIn;
  }

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

  public String getContactNumber() {
    return contactNumber;
  }

  public void setContactNumber(String contactNumber) {
    this.contactNumber = contactNumber;
  }

  public String getProgrammingLanguage() {
    return programmingLanguage;
  }

  public void setProgrammingLanguage(String programmingLanguage) {
    this.programmingLanguage = programmingLanguage;
  }

  public String getLinkedIn() {
    return linkedIn;
  }

  public void setLinkedIn(String linkedIn) {
    this.linkedIn = linkedIn;
  }
}

package com.techmcne.peopleplatform.keycloakreactivestarter.config.security;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.Value;

@Value
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReactiveKeycloakConstants {
  public static final String CLAIM_REALM_ACCESS = "realm_access";
  public static final String RESOURCE_ACCESS = "resource_access";
  public static final String ROLES = "roles";
  public static final String USERNAME_CLAIM = "preferred_username";
  public static final String EMAIL_CLAIM = "email";
}

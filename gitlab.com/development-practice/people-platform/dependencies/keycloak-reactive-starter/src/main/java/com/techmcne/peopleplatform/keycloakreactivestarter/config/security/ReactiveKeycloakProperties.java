package com.techmcne.peopleplatform.keycloakreactivestarter.config.security;

import javax.annotation.PostConstruct;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.ConstructorBinding;
import org.springframework.validation.annotation.Validated;

@Slf4j
@Validated
@Value
@ConstructorBinding
@ConfigurationProperties(prefix = "techmcne.keycloak")
public class ReactiveKeycloakProperties {

  String clientId;

  @PostConstruct
  public void logEnabledStatus() {
    log.info("keycloak-reactive-starter using client id: {}", clientId);
  }
}

package com.techmcne.peopleplatform.keycloakreactivestarter.config.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@EnableConfigurationProperties(value = ReactiveKeycloakProperties.class)
@TestPropertySource("classpath:application.properties")
class ReactiveKeycloakPropertiesTest {

  @Autowired private ReactiveKeycloakProperties subject;

  @Test
  void shouldCreateNonNullConfigurationProperties() {
    assertNotNull(subject);
  }

  @Test
  void shouldReadPropertiesFile() {
    assertEquals("some-client-id-here", subject.getClientId());
  }
}

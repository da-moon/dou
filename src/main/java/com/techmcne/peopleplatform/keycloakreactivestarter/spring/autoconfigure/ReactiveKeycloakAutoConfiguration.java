package com.techmcne.peopleplatform.keycloakreactivestarter.spring.autoconfigure;

import com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakProperties;
import com.techmcne.peopleplatform.keycloakreactivestarter.config.security.converters.ReactiveKeycloakJwtAuthenticationConverter;
import com.techmcne.peopleplatform.keycloakreactivestarter.config.security.converters.ReactiveKeycloakJwtToGrantedAuthoritiesConverter;
import java.util.Collection;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication.Type;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import reactor.core.publisher.Mono;

@Slf4j
@Configuration
@ConditionalOnWebApplication(type = Type.REACTIVE)
@ConditionalOnClass(
    name =
        "org.springframework.security.config.annotation.web.reactive.WebFluxSecurityConfiguration")
@EnableConfigurationProperties({ReactiveKeycloakProperties.class})
@RequiredArgsConstructor
public class ReactiveKeycloakAutoConfiguration {
  private final ReactiveKeycloakProperties reactiveKeycloakProperties;

  @Bean
  Converter<Jwt, Collection<GrantedAuthority>> createKeycloakAuthorizationConverter() {
    return new ReactiveKeycloakJwtToGrantedAuthoritiesConverter(reactiveKeycloakProperties);
  }

  @Bean
  Converter<Jwt, Mono<AbstractAuthenticationToken>> createKeycloakAuthenticationConverter(
      Converter<Jwt, Collection<GrantedAuthority>> converter) {
    return new ReactiveKeycloakJwtAuthenticationConverter(converter);
  }
}

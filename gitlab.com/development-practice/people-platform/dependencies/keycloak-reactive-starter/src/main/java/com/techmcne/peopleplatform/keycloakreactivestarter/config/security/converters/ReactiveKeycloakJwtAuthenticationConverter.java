package com.techmcne.peopleplatform.keycloakreactivestarter.config.security.converters;

import static com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakConstants.EMAIL_CLAIM;

import java.util.Collection;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.ReactiveJwtGrantedAuthoritiesConverterAdapter;
import org.springframework.util.Assert;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * The type Reactive keycloak jwt authentication strategy.
 *
 * @see
 *     org.springframework.security.oauth2.server.resource.authentication.ReactiveJwtAuthenticationConverter
 */
@Slf4j
public final class ReactiveKeycloakJwtAuthenticationConverter
    implements Converter<Jwt, Mono<AbstractAuthenticationToken>> {

  private final Converter<Jwt, Flux<GrantedAuthority>> jwtGrantedAuthoritiesConverter;

  public ReactiveKeycloakJwtAuthenticationConverter(
      Converter<Jwt, Collection<GrantedAuthority>> jwtGrantedAuthoritiesConverter) {
    Assert.notNull(jwtGrantedAuthoritiesConverter, "jwtGrantedAuthoritiesConverter cannot be null");
    this.jwtGrantedAuthoritiesConverter =
        new ReactiveJwtGrantedAuthoritiesConverterAdapter(jwtGrantedAuthoritiesConverter);
  }

  @Override
  public Mono<AbstractAuthenticationToken> convert(Jwt jwt) {
    return Optional.ofNullable(this.jwtGrantedAuthoritiesConverter.convert(jwt))
        .orElseGet(
            () -> {
              log.trace("No authorities returned from jwtGrantedAuthoritiesConverter.");
              return Flux.empty();
            })
        .collectList()
        .map(
            authorities -> {
              log.trace(
                  "Returned authorities from jwtGrantedAuthoritiesConverter: {}", authorities);
              return new JwtAuthenticationToken(jwt, authorities, extractUsername(jwt));
            });
  }

  private String extractUsername(Jwt jwt) {
    return jwt.hasClaim(EMAIL_CLAIM) ? jwt.getClaimAsString(EMAIL_CLAIM) : jwt.getSubject();
  }
}

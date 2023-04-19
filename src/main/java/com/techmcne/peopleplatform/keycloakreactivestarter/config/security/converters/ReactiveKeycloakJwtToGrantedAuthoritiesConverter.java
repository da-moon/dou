package com.techmcne.peopleplatform.keycloakreactivestarter.config.security.converters;

import static com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakConstants.CLAIM_REALM_ACCESS;
import static com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakConstants.RESOURCE_ACCESS;
import static com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakConstants.ROLES;
import static java.util.Collections.emptyList;
import static java.util.Collections.emptySet;

import com.techmcne.peopleplatform.keycloakreactivestarter.config.security.ReactiveKeycloakProperties;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;

@Slf4j
@RequiredArgsConstructor
public class ReactiveKeycloakJwtToGrantedAuthoritiesConverter
    implements Converter<Jwt, Collection<GrantedAuthority>> {

  private final Converter<Jwt, Collection<GrantedAuthority>> defaultAuthoritiesConverter =
      new JwtGrantedAuthoritiesConverter();

  private final ReactiveKeycloakProperties keycloakStarterProperties;

  @Override
  public Collection<GrantedAuthority> convert(Jwt source) {
    final List<String> realmRoles = extractRealmRoles(source);
    final List<String> clientRoles = extractClientRoles(source, keycloakStarterProperties);

    final Collection<GrantedAuthority> authorities =
        Stream.concat(realmRoles.stream(), clientRoles.stream())
            .map(SimpleGrantedAuthority::new)
            .collect(Collectors.toSet());
    authorities.addAll(extractDefaultGrantedAuthorities(source));
    log.trace("Found roles: {}", authorities);
    return Collections.unmodifiableCollection(authorities);
  }

  @SuppressWarnings("unchecked")
  private List<String> extractClientRoles(
      Jwt source, ReactiveKeycloakProperties reactiveKeycloakProperties) {

    final Optional<String> clientIdOptional =
        Optional.ofNullable(reactiveKeycloakProperties.getClientId())
            .filter(existingClientId -> !existingClientId.isBlank());

    if (clientIdOptional.isEmpty()) {
      return Collections.emptyList();
    }

    return Optional.ofNullable(source.getClaimAsMap(RESOURCE_ACCESS))
        .map(
            resourceAccess ->
                (Map<String, List<String>>) resourceAccess.get(clientIdOptional.orElseThrow()))
        .map(clientAccess -> clientAccess.get(ROLES))
        .orElse(emptyList());
  }

  private List<String> extractRealmRoles(Jwt source) {
    return Optional.ofNullable(source.getClaimAsMap(CLAIM_REALM_ACCESS))
        .map(realmAccessMap -> (List<String>) realmAccessMap.get(ROLES))
        .orElse(Collections.emptyList());
  }

  private Collection<GrantedAuthority> extractDefaultGrantedAuthorities(Jwt jwt) {
    return Optional.ofNullable(defaultAuthoritiesConverter.convert(jwt)).orElse(emptySet());
  }
}

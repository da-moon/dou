# Keycloak Reactive Starter

#### Required:
 - Java 11
 - Gradle

#### Build
```
> ./gradlew clean build
```

#### Run Unit Tests
```
./gradlew test
```

#### Publish
The repository is configured to request a token when the Publish step is triggered on the Gitlab CI/CD pipeline. 

### Features
- Secures a Spring Boot (Reactive only, not servlets) Restful API by enabling required spring boot dependencies.
- Extracts the Keycloak generated JWT email claim as a Username.
- Extracts the specific Keycloak client roles (realm_access) as Spring Authorities. By default, resource_access roles are considered, despite of realm_access roles existing or not.

#### Security

This starter contains a set of classes based on Spring Security dependency. It is disabled by default to not interfere with any other code implementation within this dependency.

A few steps are required in order to enable security on a rest service with Spring Boot 2.

1. Include this line to `build.gradle` file to enable `peopleplatform-keycloak-reactive-spring-boot-starter` along with Spring Security.

    ```groovy
   
   plugins {
	id 'org.springframework.boot' version '2.7.3'
	id 'io.spring.dependency-management' version '1.0.11.RELEASE'
	id 'java'
   }

   sourceCompatibility = '11'
   configurations {
        compileOnly {
            extendsFrom annotationProcessor
        }
   }
   
   repositories {
      mavenCentral()
      maven {
        url "https://gitlab.com/api/v4/projects/37984194/packages/maven"
        name "GitLab"
        credentials(HttpHeaderCredentials) {
           name = 'Deploy-Token'
           value = System.getenv("YOUR_GITLAB_MAVEN_TOKEN")
		}
        authentication {
           header(HttpHeaderAuthentication)
        }
      }
   }

   dependencies {
      implementation(
         'org.springframework.boot:spring-boot-starter-oauth2-resource-server',
         'com.techmcne:peopleplatform-keycloak-reactive-spring-boot-starter:1.0.0'
      )
   }
   
    ```

2. Add the following entries to your application.properties/application.yml file

    ```properties
    techmcne.keycloak.client-id=resource-server-client-id-in-keycloak
    spring.security.oauth2.resourceserver.jwt.issuer-uri="http://<server>:<port>/auth/realms/<your_realm_name>"
    ```
   
3. Enable your security configuration in your app by adding a WebSecurity config file like:

    ```java
   package com.digitalonus.skillbase.common.config;
   
   import org.springframework.context.annotation.Bean;
   import org.springframework.core.convert.converter.Converter;
   import org.springframework.security.authentication.AbstractAuthenticationToken;
   import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
   import org.springframework.security.config.web.server.ServerHttpSecurity;
   import org.springframework.security.oauth2.jwt.Jwt;
   import org.springframework.security.web.server.SecurityWebFilterChain;
   import reactor.core.publisher.Mono;
   
   @EnableWebFluxSecurity
   public class WebSecurityConfig {
   
   @Bean
   SecurityWebFilterChain createSpringSecurityFilterChain(
   ServerHttpSecurity serverHttpSecurity,
   Converter<Jwt, Mono<AbstractAuthenticationToken>> jwtAuthenticationConverter) {
     serverHttpSecurity
     .csrf().disable()
     .formLogin().disable()
     .httpBasic().disable()
     .authorizeExchange()
     .pathMatchers("/controller_name_here/**").hasAuthority("YOUR_KEYCLOAK_REALM_ROLE")
     .anyExchange().authenticated()
     .and()
     .oauth2ResourceServer()
     .jwt()
     .jwtAuthenticationConverter(jwtAuthenticationConverter);
     return serverHttpSecurity.build();
     }
   }

    ```
   
### Not supported features

Using `@EnableReactiveMethodSecurity` annotation along with `@PreAuthorize` is not supported if the controller does not return
a Reactive Publisher response, i.e. Flux/Mono. Returning something like `ResponseBody<Mono<MyClass>>`
is causing an error.

### Known errors.

#### Missing application.properties
When the application.properties property `spring.security.oauth2.resourceserver.jwt.issuer-uri` 
is not found or points to a Keycloak Server/Realm that doesn't exist, then the following spring start error shows:

```shell
***************************
APPLICATION FAILED TO START
***************************

Description:

Parameter 0 of method setSecurityWebFilterChains in org.springframework.security.config.annotation.web.reactive.WebFluxSecurityConfiguration required a bean of type 'org.springframework.security.oauth2.jwt.ReactiveJwtDecoder' that could not be found.


Action:

Consider defining a bean of type 'org.springframework.security.oauth2.jwt.ReactiveJwtDecoder' in your configuration.


```

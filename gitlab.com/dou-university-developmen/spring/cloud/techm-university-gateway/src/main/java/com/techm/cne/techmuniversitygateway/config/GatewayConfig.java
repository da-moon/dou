package com.techm.cne.techmuniversitygateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

  @Bean
  public RouteLocator gatewayRouteConfig(RouteLocatorBuilder builder) {
    return builder.routes()
      .route("user-service", r -> r.path("/api/users/**")
        .filters(f -> f.rewritePath("/api(?<segment>/?.*)", "/${segment}"))
        .uri("http://localhost:8080/"))
      .build();
  }
}

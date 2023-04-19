package com.techM.OpenHouseLandingRest;

import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpMethod;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@SpringBootApplication
public class OpenHouseLandingRestApplication {

  public static void main(String[] args) {
    SpringApplication.run(OpenHouseLandingRestApplication.class, args);
  }

}

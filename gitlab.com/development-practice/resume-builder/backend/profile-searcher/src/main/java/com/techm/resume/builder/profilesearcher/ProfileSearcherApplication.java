/**
 * This file contains the project main function.
 *
 * <p>Info
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.profilesearcher;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

/**
 * We define the project starting point.
 */
@SpringBootApplication
@EnableEurekaClient
@EnableAutoConfiguration
public class ProfileSearcherApplication {

    public static void main(final String[] args) {
        SpringApplication.run(ProfileSearcherApplication.class, args);
    }

}
